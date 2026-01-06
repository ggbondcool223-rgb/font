import 'dart:typed_data';
import 'dart:math' as math;

class TtfGenerator {
  static Uint8List generateTtfFromSvg(String svgContent, String fontName) {
    final glyphs = _parseSvgFont(svgContent);
    final ttfBytes = _generateTtfFile(fontName, glyphs);
    return ttfBytes;
  }

  static Map<String, String> _parseSvgFont(String svgContent) {
    final glyphs = <String, String>{};
    final glyphRegex = RegExp(
      r'<glyph[^>]*unicode="([^"]+)"[^>]*d="([^"]*)"[^>]*/>',
      multiLine: true,
    );

    for (final match in glyphRegex.allMatches(svgContent)) {
      final unicode = match.group(1);
      final pathData = match.group(2);

      if (unicode != null && pathData != null && pathData.isNotEmpty) {
        glyphs[unicode] = pathData;
      }
    }

    return glyphs;
  }

  static Uint8List _generateTtfFile(
    String fontName,
    Map<String, String> glyphs,
  ) {
    final glyphDataList = <Uint8List>[];

    final notdefWriter = ByteDataWriter();
    notdefWriter.writeInt16(0);
    notdefWriter.writeInt16(0);
    notdefWriter.writeInt16(0);
    notdefWriter.writeInt16(0);
    notdefWriter.writeInt16(0);
    glyphDataList.add(notdefWriter.toBytes());

    for (final entry in glyphs.entries) {
      final pathData = entry.value;
      if (pathData.isEmpty) {
        final emptyWriter = ByteDataWriter();
        emptyWriter.writeInt16(0);
        emptyWriter.writeInt16(0);
        emptyWriter.writeInt16(0);
        emptyWriter.writeInt16(0);
        emptyWriter.writeInt16(0);
        glyphDataList.add(emptyWriter.toBytes());
      } else {
        glyphDataList.add(_convertSvgPathToGlyph(pathData));
      }
    }

    final writer = ByteDataWriter();
    _writeTtfHeader(writer, fontName, glyphs, glyphDataList);
    return writer.toBytes();
  }

  static void _writeTtfHeader(
    ByteDataWriter writer,
    String fontName,
    Map<String, String> glyphs,
    List<Uint8List> glyphDataList,
  ) {
    final numTables = 9;
    final searchRange =
        (math.pow(2, (math.log(numTables) / math.ln2).floor()) * 16).toInt();
    final entrySelector = (math.log(searchRange / 16) / math.ln2).floor();
    final rangeShift = numTables * 16 - searchRange;

    writer.writeUint32(0x00010000);
    writer.writeUint16(numTables);
    writer.writeUint16(searchRange);
    writer.writeUint16(entrySelector);
    writer.writeUint16(rangeShift);

    final tables = <String, Uint8List>{};
    tables['head'] = _generateHeadTable();
    tables['hhea'] = _generateHheaTable(glyphs.length);
    tables['maxp'] = _generateMaxpTable(glyphs.length);
    tables['name'] = _generateNameTable(fontName);
    tables['cmap'] = _generateCmapTable(glyphs);
    tables['hmtx'] = _generateHmtxTable(glyphs.length);
    tables['loca'] = _generateLocaTable(glyphDataList);
    tables['glyf'] = _generateGlyfTableFromData(glyphDataList);
    tables['post'] = _generatePostTable();

    var offset = 12 + numTables * 16;
    final tableRecords = <_TableRecord>[];

    for (final entry in tables.entries) {
      final tag = entry.key;
      final data = entry.value;
      final checksum = _calculateChecksum(data);

      tableRecords.add(
        _TableRecord(
          tag: tag,
          checksum: checksum,
          offset: offset,
          length: data.length,
        ),
      );

      offset += (data.length + 3) & ~3;
    }

    tableRecords.sort((a, b) => a.tag.compareTo(b.tag));

    for (final record in tableRecords) {
      writer.writeString(record.tag);
      writer.writeUint32(record.checksum);
      writer.writeUint32(record.offset);
      writer.writeUint32(record.length);
    }

    for (final record in tableRecords) {
      final data = tables[record.tag]!;
      writer.writeBytes(data);

      final padding = (4 - (data.length % 4)) % 4;
      for (var i = 0; i < padding; i++) {
        writer.writeUint8(0);
      }
    }
  }

  static Uint8List _generateHeadTable() {
    final writer = ByteDataWriter();
    writer.writeUint32(0x00010000);
    writer.writeUint32(0x00010000);
    writer.writeUint32(0);
    writer.writeUint32(0x5F0F3CF5);
    writer.writeUint16(0);
    writer.writeUint16(1000);
    writer.writeInt64(0);
    writer.writeInt64(0);
    writer.writeInt16(-200);
    writer.writeInt16(-200);
    writer.writeInt16(1200);
    writer.writeInt16(1200);
    writer.writeUint16(0);
    writer.writeUint16(8);
    writer.writeInt16(2);
    writer.writeInt16(0);
    writer.writeInt16(0);
    return writer.toBytes();
  }

  static Uint8List _generateHheaTable(int numGlyphs) {
    final writer = ByteDataWriter();
    writer.writeUint32(0x00010000);
    writer.writeInt16(800);
    writer.writeInt16(-200);
    writer.writeInt16(0);
    writer.writeUint16(1000);
    writer.writeInt16(0);
    writer.writeInt16(0);
    writer.writeInt16(1000);
    writer.writeInt16(1);
    writer.writeInt16(0);
    writer.writeInt16(0);
    writer.writeInt16(0);
    writer.writeInt16(0);
    writer.writeInt16(0);
    writer.writeInt16(0);
    writer.writeInt16(0);
    writer.writeUint16(numGlyphs + 1);
    return writer.toBytes();
  }

  static Uint8List _generateMaxpTable(int numGlyphs) {
    final writer = ByteDataWriter();
    writer.writeUint32(0x00010000);
    writer.writeUint16(numGlyphs + 1);
    writer.writeUint16(0);
    writer.writeUint16(0);
    writer.writeUint16(0);
    writer.writeUint16(0);
    writer.writeUint16(2);
    writer.writeUint16(0);
    writer.writeUint16(0);
    writer.writeUint16(0);
    writer.writeUint16(0);
    writer.writeUint16(0);
    writer.writeUint16(0);
    writer.writeUint16(0);
    return writer.toBytes();
  }

  static Uint8List _generateNameTable(String fontName) {
    final writer = ByteDataWriter();

    final familyBytes = _encodeString(fontName);
    final subfamilyBytes = _encodeString('Regular');
    final fullNameBytes = _encodeString(fontName);
    final postScriptBytes = _encodeString(fontName.replaceAll(' ', ''));

    final nameRecords = [
      _NameRecord(nameID: 1, string: familyBytes),
      _NameRecord(nameID: 2, string: subfamilyBytes),
      _NameRecord(nameID: 4, string: fullNameBytes),
      _NameRecord(nameID: 6, string: postScriptBytes),
    ];

    writer.writeUint16(0);
    writer.writeUint16(nameRecords.length);
    writer.writeUint16(6 + nameRecords.length * 12);

    var stringOffset = 0;
    for (final record in nameRecords) {
      writer.writeUint16(3);
      writer.writeUint16(1);
      writer.writeUint16(0x0409);
      writer.writeUint16(record.nameID);
      writer.writeUint16(record.string.length);
      writer.writeUint16(stringOffset);
      stringOffset += record.string.length;
    }

    for (final record in nameRecords) {
      writer.writeBytes(record.string);
    }

    return writer.toBytes();
  }

  static Uint8List _generateCmapTable(Map<String, String> glyphs) {
    final writer = ByteDataWriter();
    writer.writeUint16(0);
    writer.writeUint16(1);
    writer.writeUint16(3);
    writer.writeUint16(1);
    writer.writeUint32(12);

    final segments = <_CmapSegment>[];
    var glyphIndex = 1;

    for (final char in glyphs.keys) {
      if (char.isNotEmpty) {
        final codePoint = char.codeUnitAt(0);
        segments.add(
          _CmapSegment(
            startCode: codePoint,
            endCode: codePoint,
            glyphId: glyphIndex,
          ),
        );
        glyphIndex++;
      }
    }

    segments.add(_CmapSegment(startCode: 0xFFFF, endCode: 0xFFFF, glyphId: 0));

    final segCount = segments.length;
    final searchRange =
        (math.pow(2, (math.log(segCount) / math.ln2).floor()) * 2).toInt();
    final entrySelector = (math.log(searchRange / 2) / math.ln2).floor();
    final rangeShift = segCount * 2 - searchRange;

    writer.writeUint16(4);
    writer.writeUint16(16 + segCount * 8);
    writer.writeUint16(0);
    writer.writeUint16(segCount * 2);
    writer.writeUint16(searchRange);
    writer.writeUint16(entrySelector);
    writer.writeUint16(rangeShift);

    for (final segment in segments) {
      writer.writeUint16(segment.endCode);
    }

    writer.writeUint16(0);

    for (final segment in segments) {
      writer.writeUint16(segment.startCode);
    }

    for (final segment in segments) {
      writer.writeInt16(segment.glyphId - segment.startCode);
    }

    for (var i = 0; i < segCount; i++) {
      writer.writeUint16(0);
    }

    return writer.toBytes();
  }

  static Uint8List _generateHmtxTable(int numGlyphs) {
    final writer = ByteDataWriter();
    writer.writeUint16(500);
    writer.writeInt16(0);

    for (var i = 0; i < numGlyphs; i++) {
      writer.writeUint16(1000);
      writer.writeInt16(0);
    }

    return writer.toBytes();
  }

  static Uint8List _generateLocaTable(List<Uint8List> glyphDataList) {
    final writer = ByteDataWriter();

    var offset = 0;
    for (final glyphData in glyphDataList) {
      writer.writeUint16((offset ~/ 2));
      offset += glyphData.length;
      if (offset % 2 != 0) offset++;
    }

    writer.writeUint16((offset ~/ 2));
    return writer.toBytes();
  }

  static Uint8List _generateGlyfTableFromData(List<Uint8List> glyphDataList) {
    final writer = ByteDataWriter();

    for (final glyphData in glyphDataList) {
      writer.writeBytes(glyphData);
      if (glyphData.length % 2 != 0) {
        writer.writeUint8(0);
      }
    }

    return writer.toBytes();
  }

  static Uint8List _convertSvgPathToGlyph(String pathData) {
    final contours = _parseSvgPath(pathData);

    if (contours.isEmpty) {
      final writer = ByteDataWriter();
      writer.writeInt16(0);
      writer.writeInt16(0);
      writer.writeInt16(0);
      writer.writeInt16(0);
      writer.writeInt16(0);
      return writer.toBytes();
    }

    var xMin = 10000;
    var yMin = 10000;
    var xMax = -10000;
    var yMax = -10000;

    for (final contour in contours) {
      for (final point in contour.points) {
        xMin = math.min(xMin, point.x);
        yMin = math.min(yMin, point.y);
        xMax = math.max(xMax, point.x);
        yMax = math.max(yMax, point.y);
      }
    }

    final writer = ByteDataWriter();
    writer.writeInt16(contours.length);
    writer.writeInt16(xMin);
    writer.writeInt16(yMin);
    writer.writeInt16(xMax);
    writer.writeInt16(yMax);

    var pointIndex = 0;
    for (final contour in contours) {
      pointIndex += contour.points.length;
      writer.writeUint16(pointIndex - 1);
    }

    writer.writeUint16(0);

    final allPoints = <_GlyphPoint>[];
    for (final contour in contours) {
      allPoints.addAll(contour.points);
    }

    final xCoords = <int>[];
    final yCoords = <int>[];
    var prevX = 0;
    var prevY = 0;

    for (final point in allPoints) {
      xCoords.add(point.x - prevX);
      yCoords.add(point.y - prevY);
      prevX = point.x;
      prevY = point.y;
    }

    for (var i = 0; i < allPoints.length; i++) {
      var flag = 0;
      if (allPoints[i].onCurve) {
        flag |= 0x01;
      }
      writer.writeUint8(flag);
    }

    for (final dx in xCoords) {
      writer.writeInt16(dx);
    }

    for (final dy in yCoords) {
      writer.writeInt16(dy);
    }

    return writer.toBytes();
  }

  static List<_Contour> _parseSvgPath(String pathData) {
    final contours = <_Contour>[];
    var currentContour = <_GlyphPoint>[];

    final commands = _tokenizePath(pathData);

    double currentX = 0;
    double currentY = 0;
    double startX = 0;
    double startY = 0;

    for (var i = 0; i < commands.length; i++) {
      final cmd = commands[i];

      if (cmd == 'M' || cmd == 'm') {
        if (currentContour.isNotEmpty) {
          contours.add(_Contour(points: currentContour));
          currentContour = [];
        }

        i++;
        final x = double.tryParse(commands[i]) ?? 0;
        i++;
        final y = double.tryParse(commands[i]) ?? 0;

        if (cmd == 'M') {
          currentX = x;
          currentY = y;
        } else {
          currentX += x;
          currentY += y;
        }

        startX = currentX;
        startY = currentY;

        currentContour.add(
          _GlyphPoint(x: currentX.round(), y: currentY.round(), onCurve: true),
        );
      } else if (cmd == 'L' || cmd == 'l') {
        i++;
        final x = double.tryParse(commands[i]) ?? 0;
        i++;
        final y = double.tryParse(commands[i]) ?? 0;

        if (cmd == 'L') {
          currentX = x;
          currentY = y;
        } else {
          currentX += x;
          currentY += y;
        }

        currentContour.add(
          _GlyphPoint(x: currentX.round(), y: currentY.round(), onCurve: true),
        );
      } else if (cmd == 'Q' || cmd == 'q') {
        i++;
        final cx = double.tryParse(commands[i]) ?? 0;
        i++;
        final cy = double.tryParse(commands[i]) ?? 0;
        i++;
        final x = double.tryParse(commands[i]) ?? 0;
        i++;
        final y = double.tryParse(commands[i]) ?? 0;

        double controlX, controlY, endX, endY;

        if (cmd == 'Q') {
          controlX = cx;
          controlY = cy;
          endX = x;
          endY = y;
        } else {
          controlX = currentX + cx;
          controlY = currentY + cy;
          endX = currentX + x;
          endY = currentY + y;
        }

        currentContour.add(
          _GlyphPoint(x: controlX.round(), y: controlY.round(), onCurve: false),
        );

        currentContour.add(
          _GlyphPoint(x: endX.round(), y: endY.round(), onCurve: true),
        );

        currentX = endX;
        currentY = endY;
      } else if (cmd == 'Z' || cmd == 'z') {
        if (currentContour.isNotEmpty) {
          final lastPoint = currentContour.last;
          if (lastPoint.x != startX.round() || lastPoint.y != startY.round()) {
            currentContour.add(
              _GlyphPoint(x: startX.round(), y: startY.round(), onCurve: true),
            );
          }

          contours.add(_Contour(points: currentContour));
          currentContour = [];
        }

        currentX = startX;
        currentY = startY;
      }
    }

    if (currentContour.isNotEmpty) {
      contours.add(_Contour(points: currentContour));
    }

    return contours;
  }

  static List<String> _tokenizePath(String pathData) {
    final tokens = <String>[];
    var current = '';

    for (var i = 0; i < pathData.length; i++) {
      final char = pathData[i];

      if (char == ' ' || char == ',') {
        if (current.isNotEmpty) {
          tokens.add(current);
          current = '';
        }
      } else if ('MmLlQqCcAaZz'.contains(char)) {
        if (current.isNotEmpty) {
          tokens.add(current);
          current = '';
        }
        tokens.add(char);
      } else if (char == '-' && current.isNotEmpty && !current.endsWith('e')) {
        tokens.add(current);
        current = char;
      } else {
        current += char;
      }
    }

    if (current.isNotEmpty) {
      tokens.add(current);
    }

    return tokens;
  }

  static Uint8List _generatePostTable() {
    final writer = ByteDataWriter();
    writer.writeUint32(0x00030000);
    writer.writeInt32(0);
    writer.writeInt16(0);
    writer.writeInt16(0);
    writer.writeUint32(0);
    writer.writeUint32(0);
    writer.writeUint32(0);
    writer.writeUint32(0);
    writer.writeUint32(0);
    return writer.toBytes();
  }

  static int _calculateChecksum(Uint8List data) {
    var sum = 0;
    for (var i = 0; i < data.length; i += 4) {
      var value = 0;
      for (var j = 0; j < 4 && i + j < data.length; j++) {
        value = (value << 8) | data[i + j];
      }
      sum = (sum + value) & 0xFFFFFFFF;
    }
    return sum;
  }

  static Uint8List _encodeString(String str) {
    final bytes = <int>[];
    for (var i = 0; i < str.length; i++) {
      final code = str.codeUnitAt(i);
      bytes.add((code >> 8) & 0xFF);
      bytes.add(code & 0xFF);
    }
    return Uint8List.fromList(bytes);
  }
}

class ByteDataWriter {
  final _buffer = <int>[];

  void writeUint8(int value) {
    _buffer.add(value & 0xFF);
  }

  void writeUint16(int value) {
    _buffer.add((value >> 8) & 0xFF);
    _buffer.add(value & 0xFF);
  }

  void writeInt16(int value) {
    writeUint16(value & 0xFFFF);
  }

  void writeUint32(int value) {
    _buffer.add((value >> 24) & 0xFF);
    _buffer.add((value >> 16) & 0xFF);
    _buffer.add((value >> 8) & 0xFF);
    _buffer.add(value & 0xFF);
  }

  void writeInt32(int value) {
    writeUint32(value & 0xFFFFFFFF);
  }

  void writeInt64(int value) {
    writeUint32((value >> 32) & 0xFFFFFFFF);
    writeUint32(value & 0xFFFFFFFF);
  }

  void writeString(String str) {
    for (var i = 0; i < str.length; i++) {
      _buffer.add(str.codeUnitAt(i));
    }
  }

  void writeBytes(Uint8List bytes) {
    _buffer.addAll(bytes);
  }

  Uint8List toBytes() {
    return Uint8List.fromList(_buffer);
  }
}

class _TableRecord {
  final String tag;
  final int checksum;
  final int offset;
  final int length;

  _TableRecord({
    required this.tag,
    required this.checksum,
    required this.offset,
    required this.length,
  });
}

class _CmapSegment {
  final int startCode;
  final int endCode;
  final int glyphId;

  _CmapSegment({
    required this.startCode,
    required this.endCode,
    required this.glyphId,
  });
}

class _Contour {
  final List<_GlyphPoint> points;

  _Contour({required this.points});
}

class _GlyphPoint {
  final int x;
  final int y;
  final bool onCurve;

  _GlyphPoint({required this.x, required this.y, required this.onCurve});
}

class _NameRecord {
  final int nameID;
  final Uint8List string;

  _NameRecord({required this.nameID, required this.string});
}
