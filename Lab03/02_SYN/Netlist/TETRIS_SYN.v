/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03
// Date      : Sun Sep 29 21:43:00 2024
/////////////////////////////////////////////////////////////


module TETRIS ( rst_n, clk, in_valid, tetrominoes, position, tetris_valid, 
        score_valid, fail, score, tetris );
  input [2:0] tetrominoes;
  input [2:0] position;
  output [3:0] score;
  output [71:0] tetris;
  input rst_n, clk, in_valid;
  output tetris_valid, score_valid, fail;
  wire   n986, n988, n989, n990, n991, n992, n995, n996, n997, n998, n999,
         n1000, n1001, n1002, n1003, n1004, n1005, n1006, n1007, n1008, n1009,
         n1010, n1011, n1012, n1013, n1014, n1015, n1016, n1017, n1018, n1019,
         n1020, n1021, n1022, n1023, n1024, n1025, n1026, n1027, n1028, n1029,
         n1030, n1031, n1032, n1033, n1034, n1035, n1036, n1037, n1038, n1039,
         n1040, n1041, n1042, n1043, n1044, n1045, n1046, n1047, n1048, n1049,
         n1050, n1051, n1052, n1053, n1054, n1055, n1056, n1057, n1058, n1059,
         n1060, n1061, n1062, n1063, n1064, n1065, n1066, n1067, n1068, n1069,
         n1070, n1071, n1072, n1073, n1074, n1075, n1076, n1077, n1078, n1079,
         n1080, n1081, n1082, n1083, n1084, n1085, n1086, n1087, n1088, n1089,
         n1090, n1091, n1092, n1093, n1094, n1095, n1096, n1097, n1098, n1099,
         n1100, n1101, n1102, n1103, n1104, n1105, n1106, n1107, n1108, n1109,
         n1110, n1111, n1112, n1113, n1114, n1115, n1116, n1117, n1118, n1119,
         n1120, n1121, n1122, n1123, n1124, n1125, n1126, n1127, n1128, n1129,
         n1130, n1131, n1132, n1133, n1134, n1135, n1136, n1137, n1138, n1139,
         n1140, n1141, n1142, n1143, n1144, n1145, n1146, n1147, n1148, n1149,
         n1150, n1151, n1152, n1153, n1154, n1155, n1156, n1157, n1158, n1159,
         n1160, n1161, n1162, n1163, n1164, n1165, n1166, n1167, n1168, n1169,
         n1170, n1171, n1172, n1173, n1174, n1175, n1176, n1177, n1178, n1179,
         n1180, n1181, n1182, n1183, n1184, n1185, n1186, n1187, n1188, n1189,
         n1190, n1191, n1192, n1193, n1194, n1195, n1196, n1197, n1198, n1199,
         n1200, n1201, n1202, n1203, n1204, n1205, n1206, n1207, n1208, n1209,
         n1210, n1211, n1212, n1213, n1214, n1215, n1216, n1217, n1218, n1219,
         n1220, n1221, n1222, n1223, n1224, n1225, n1226, n1227, n1228, n1229,
         n1230, n1231, n1232, n1233, n1234, n1235, n1236, n1237, n1238, n1239,
         n1240, n1241, n1242, n1243, n1244, n1245, n1246, n1247, n1248, n1249,
         n1250, n1251, n1252, n1253, n1254, n1255, n1256, n1257, n1258, n1259,
         n1260, n1261, n1262, n1263, n1264, n1265, n1266, n1267, n1268, n1269,
         n1270, n1271, n1272, n1273, n1274, n1275, n1276, n1277, n1278, n1279,
         n1280, n1281, n1282, n1283, n1284, n1285, n1286, n1287, n1288, n1289,
         n1290, n1291, n1292, n1293, n1294, n1295, n1296, n1297, n1298, n1299,
         n1300, n1301, n1302, n1303, n1304, n1305, n1306, n1307, n1308, n1309,
         n1310, n1311, n1312, n1313, n1314, n1315, n1316, n1317, n1318, n1319,
         n1320, n1321, n1322, n1323, n1324, n1325, n1326, n1327, n1328, n1329,
         n1330, n1331, n1332, n1333, n1334, n1335, n1336, n1337, n1338, n1339,
         n1340, n1341, n1342, n1343, n1344, n1345, n1346, n1347, n1348, n1349,
         n1350, n1351, n1352, n1353, n1354, n1355, n1356, n1357, n1358, n1359,
         n1360, n1361, n1362, n1363, n1364, n1365, n1366, n1367, n1368, n1369,
         n1370, n1371, n1372, n1373, n1374, n1375, n1376, n1377, n1378, n1379,
         n1380, n1381, n1382, n1383, n1384, n1385, n1386, n1387, n1388, n1389,
         n1390, n1391, n1392, n1393, n1394, n1395, n1396, n1397, n1398, n1399,
         n1400, n1401, n1402, n1403, n1404, n1405, n1406, n1407, n1408, n1409,
         n1410, n1411, n1412, n1413, n1414, n1415, n1416, n1417, n1418, n1419,
         n1420, n1421, n1422, n1423, n1424, n1425, n1426, n1427, n1428, n1429,
         n1430, n1431, n1432, n1433, n1434, n1435, n1436, n1437, n1438, n1439,
         n1440, n1441, n1442, n1443, n1444, n1445, n1446, n1447, n1448, n1449,
         n1450, n1451, n1452, n1453, n1454, n1455, n1456, n1457, n1458, n1459,
         n1460, n1461, n1462, n1463, n1464, n1465, n1466, n1467, n1468, n1469,
         n1470, n1471, n1472, n1473, n1474, n1475, n1476, n1477, n1478, n1479,
         n1480, n1481, n1482, n1483, n1484, n1485, n1486, n1487, n1488, n1489,
         n1490, n1491, n1492, n1493, n1494, n1495, n1496, n1497, n1498, n1499,
         n1500, n1501, n1502, n1503, n1504, n1505, n1506, n1507, n1508, n1509,
         n1510, n1511, n1512, n1513, n1514, n1515, n1516, n1517, n1518, n1519,
         n1520, n1521, n1522, n1523, n1524, n1525, n1526, n1527, n1528, n1529,
         n1530, n1531, n1532, n1533, n1534, n1535, n1536, n1537, n1538, n1539,
         n1540, n1541, n1542, n1543, n1544, n1545, n1546, n1547, n1548, n1549,
         n1550, n1551, n1552, n1553, n1554, n1555, n1556, n1557, n1558, n1559,
         n1560, n1561, n1562, n1563, n1564, n1565, n1566, n1567, n1568, n1569,
         n1570, n1571, n1572, n1573, n1574, n1575, n1576, n1577, n1578, n1579,
         n1580, n1581, n1582, n1583, n1584, n1585, n1586, n1587, n1588, n1589,
         n1590, n1591, n1592, n1593, n1594, n1595, n1596, n1597, n1598, n1599,
         n1600, n1601, n1602, n1603, n1604, n1605, n1606, n1607, n1608, n1609,
         n1610, n1611, n1612, n1613, n1614, n1615, n1616, n1617, n1618, n1619,
         n1620, n1621, n1622, n1623, n1624, n1625, n1626, n1627, n1628, n1629,
         n1630, n1631, n1632, n1633, n1634, n1635, n1636, n1637, n1638, n1639,
         n1640, n1641, n1642, n1643, n1644, n1645, n1646, n1647, n1648, n1649,
         n1650, n1651, n1652, n1653, n1654, n1655, n1656, n1657, n1658, n1659,
         n1660, n1661, n1662, n1663, n1664, n1665, n1666, n1667, n1668, n1669,
         n1670, n1671, n1672, n1673, n1674, n1675, n1676, n1677, n1678, n1679,
         n1680, n1681, n1682, n1683, n1684, n1685, n1686, n1687, n1688, n1689,
         n1690, n1691, n1692, n1693, n1694, n1695, n1696, n1697, n1698, n1699,
         n1700, n1701, n1702, n1703, n1704, n1705, n1706, n1707, n1708, n1709,
         n1710, n1711, n1712, n1713, n1714, n1715, n1716, n1717, n1718, n1719,
         n1720, n1721, n1722, n1723, n1724, n1725, n1726, n1727, n1728, n1729,
         n1730, n1731, n1732, n1733, n1734, n1735, n1736, n1737, n1738, n1739,
         n1740, n1741, n1742, n1743, n1744, n1745, n1746, n1747, n1748, n1749,
         n1750, n1751, n1752, n1753, n1754, n1755, n1756, n1757, n1758, n1759,
         n1760, n1761, n1762, n1763, n1764, n1765, n1766, n1767, n1768, n1769,
         n1770, n1771, n1772, n1773, n1774, n1775, n1776, n1777, n1778, n1779,
         n1780, n1781, n1782, n1783, n1784, n1785, n1786, n1787, n1788, n1789,
         n1790, n1791, n1792, n1793, n1794, n1795, n1796, n1797, n1798, n1799,
         n1800, n1801, n1802, n1803, n1804, n1805, n1806, n1807, n1808, n1809,
         n1810, n1811, n1812, n1813, n1814, n1815, n1816, n1817, n1818, n1819,
         n1820, n1821, n1822, n1823, n1824, n1825, n1826, n1827, n1828, n1829,
         n1830, n1831, n1832, n1833, n1834, n1835, n1836, n1837, n1838, n1839,
         n1840, n1841, n1842, n1843, n1844, n1845, n1846, n1847, n1848, n1849,
         n1850, n1851, n1852, n1853, n1854, n1855, n1856, n1857, n1858, n1859,
         n1860, n1861, n1862, n1863, n1864, n1865, n1866, n1867, n1868, n1869,
         n1870, n1871, n1872, n1873, n1874, n1875, n1876, n1877, n1878, n1879,
         n1880, n1881, n1882, n1883, n1884, n1885, n1886, n1887, n1888, n1889,
         n1890, n1891, n1892, n1893, n1894, n1895, n1896, n1897, n1898, n1899,
         n1900, n1901, n1902, n1903, n1904, n1905, n1906, n1907, n1908, n1909,
         n1910, n1911, n1912, n1913, n1914, n1915, n1916, n1917, n1918, n1919,
         n1920, n1921, n1922, n1923, n1924, n1925, n1926, n1927, n1928, n1929,
         n1930, n1931, n1932, n1933, n1934, n1935, n1936, n1937, n1938, n1939,
         n1940, n1941, n1942, n1943, n1944, n1945, n1946, n1947, n1948, n1949,
         n1950, n1951, n1952, n1953, n1954, n1955, n1956, n1957, n1958, n1959,
         n1960, n1961, n1962, n1963, n1964, n1965, n1966, n1967, n1968, n1969,
         n1970, n1971, n1972, n1973, n1974, n1975, n1976, n1977, n1978, n1979,
         n1980, n1981, n1982, n1983, n1984, n1985, n1986, n1987, n1988, n1989,
         n1990, n1991, n1992, n1993, n1994, n1995, n1996, n1997, n1998, n1999,
         n2000, n2001, n2002, n2003, n2004, n2005, n2006, n2007, n2008, n2009,
         n2010, n2011, n2012, n2013, n2014, n2015, n2016, n2017, n2018, n2019,
         n2020, n2021, n2022, n2023, n2024, n2025, n2026, n2027, n2028, n2029,
         n2030, n2031, n2032, n2033, n2034, n2035, n2036, n2037, n2038, n2039,
         n2040, n2041, n2042, n2043, n2044, n2045, n2046, n2047, n2048, n2049,
         n2050, n2051, n2052, n2053, n2054, n2055, n2056, n2057, n2058, n2059,
         n2060, n2061, n2062, n2063, n2064, n2065, n2066, n2067, n2068, n2069,
         n2070, n2071, n2072, n2073, n2074, n2075, n2076, n2077, n2078, n2079,
         n2080, n2081, n2082, n2083, n2084, n2085, n2086, n2087, n2088, n2089,
         n2090, n2091, n2092, n2093, n2094, n2095, n2096, n2097, n2098, n2099,
         n2100, n2101, n2102, n2103, n2104, n2105, n2106, n2107, n2108, n2109,
         n2110, n2111, n2112, n2113, n2114, n2115, n2116, n2117, n2118, n2119,
         n2120, n2121, n2122, n2123, n2124, n2125, n2126, n2127, n2128, n2129,
         n2130, n2131, n2132, n2133, n2134, n2135, n2136, n2137, n2138, n2139,
         n2140, n2141, n2142, n2143, n2144, n2145, n2146, n2147, n2148, n2149,
         n2150, n2151, n2152, n2153, n2154, n2155, n2156, n2157, n2158, n2159,
         n2160, n2161, n2162, n2163, n2164, n2166, n2167, n2168, n2169, n2170,
         n2171, n2172, n2173, n2174, n2175, n2176, n2177, n2178, n2179, n2180,
         n2181, n2182, n2183, n2184, n2185, n2186, n2187, n2188, n2189, n2190,
         n2191, n2192, n2193, n2194, n2195, n2196, n2197, n2198, n2199, n2200,
         n2201, n2202, n2203, n2204, n2205, n2206, n2207, n2208, n2209, n2210,
         n2211, n2212, n2213, n2214, n2215, n2216, n2217, n2218;
  wire   [1:0] c_state;
  wire   [83:0] tetris_temp;
  wire   [3:0] cnt;
  wire   [3:0] n_cnt;
  wire   [83:0] n_tetris_temp;
  wire   [2:0] score_temp;
  wire   [2:0] n_score_temp;

  DFFRHQXL tetris_temp_reg_12__0_ ( .D(n_tetris_temp[6]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[6]) );
  DFFRHQXL tetris_temp_reg_12__1_ ( .D(n_tetris_temp[7]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[7]) );
  DFFRHQXL tetris_temp_reg_8__0_ ( .D(n_tetris_temp[30]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[30]) );
  DFFRHQXL tetris_temp_reg_7__0_ ( .D(n_tetris_temp[36]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[36]) );
  DFFRHQXL tetris_temp_reg_5__0_ ( .D(n_tetris_temp[48]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[48]) );
  DFFRHQXL tetris_temp_reg_4__0_ ( .D(n_tetris_temp[54]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[54]) );
  DFFRHQXL tetris_temp_reg_0__3_ ( .D(n_tetris_temp[81]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[81]) );
  DFFRHQXL tetris_temp_reg_0__5_ ( .D(n_tetris_temp[83]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[83]) );
  DFFRHQXL c_state_reg_0_ ( .D(n986), .CK(clk), .RN(rst_n), .Q(c_state[0]) );
  DFFRHQXL tetris_temp_reg_13__4_ ( .D(n_tetris_temp[4]), .CK(clk), .RN(rst_n), 
        .Q(tetris_temp[4]) );
  DFFRHQXL tetris_temp_reg_13__5_ ( .D(n_tetris_temp[5]), .CK(clk), .RN(rst_n), 
        .Q(tetris_temp[5]) );
  DFFRHQXL tetris_temp_reg_12__4_ ( .D(n_tetris_temp[10]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[10]) );
  DFFRHQXL tetris_temp_reg_12__5_ ( .D(n_tetris_temp[11]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[11]) );
  DFFRHQXL cnt_reg_0_ ( .D(n_cnt[0]), .CK(clk), .RN(n989), .Q(cnt[0]) );
  DFFRHQXL cnt_reg_1_ ( .D(n_cnt[1]), .CK(clk), .RN(n989), .Q(cnt[1]) );
  DFFRHQXL cnt_reg_2_ ( .D(n_cnt[2]), .CK(clk), .RN(n989), .Q(cnt[2]) );
  DFFRHQXL cnt_reg_3_ ( .D(n_cnt[3]), .CK(clk), .RN(n989), .Q(cnt[3]) );
  DFFRHQXL score_temp_reg_0_ ( .D(n_score_temp[0]), .CK(clk), .RN(n989), .Q(
        score_temp[0]) );
  DFFRHQXL score_temp_reg_1_ ( .D(n_score_temp[1]), .CK(clk), .RN(n989), .Q(
        score_temp[1]) );
  DFFRHQXL score_temp_reg_2_ ( .D(n_score_temp[2]), .CK(clk), .RN(n989), .Q(
        score_temp[2]) );
  DFFRHQXL tetris_temp_reg_13__0_ ( .D(n_tetris_temp[0]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[0]) );
  DFFRHQXL tetris_temp_reg_13__1_ ( .D(n_tetris_temp[1]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[1]) );
  DFFRHQXL tetris_temp_reg_13__2_ ( .D(n_tetris_temp[2]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[2]) );
  DFFRHQXL tetris_temp_reg_13__3_ ( .D(n_tetris_temp[3]), .CK(clk), .RN(rst_n), 
        .Q(tetris_temp[3]) );
  DFFRHQXL tetris_temp_reg_1__4_ ( .D(n_tetris_temp[76]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[76]) );
  DFFRHQXL tetris_temp_reg_1__0_ ( .D(n_tetris_temp[72]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[72]) );
  DFFRHQXL tetris_temp_reg_1__5_ ( .D(n_tetris_temp[77]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[77]) );
  DFFRHQXL tetris_temp_reg_0__1_ ( .D(n_tetris_temp[79]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[79]) );
  DFFRHQXL tetris_temp_reg_0__2_ ( .D(n_tetris_temp[80]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[80]) );
  DFFRHQXL tetris_temp_reg_1__3_ ( .D(n_tetris_temp[75]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[75]) );
  DFFRHQXL tetris_temp_reg_2__0_ ( .D(n_tetris_temp[66]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[66]) );
  DFFRHQXL tetris_temp_reg_1__2_ ( .D(n_tetris_temp[74]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[74]) );
  DFFRHQXL tetris_temp_reg_0__4_ ( .D(n_tetris_temp[82]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[82]) );
  DFFRHQXL tetris_temp_reg_2__3_ ( .D(n_tetris_temp[69]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[69]) );
  DFFSX1 c_state_reg_1_ ( .D(n2164), .CK(clk), .SN(rst_n), .QN(c_state[1]) );
  DFFRX4 tetris_temp_reg_6__2_ ( .D(n_tetris_temp[44]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[44]), .QN(n2188) );
  DFFRX4 tetris_temp_reg_8__1_ ( .D(n_tetris_temp[31]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[31]), .QN(n2197) );
  DFFRX4 tetris_temp_reg_10__0_ ( .D(n_tetris_temp[18]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[18]), .QN(n2208) );
  DFFRX4 tetris_temp_reg_6__0_ ( .D(n_tetris_temp[42]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[42]), .QN(n2186) );
  DFFRX4 tetris_temp_reg_10__2_ ( .D(n_tetris_temp[20]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[20]), .QN(n2210) );
  DFFRX4 tetris_temp_reg_6__3_ ( .D(n_tetris_temp[45]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[45]), .QN(n2189) );
  DFFRX4 tetris_temp_reg_10__3_ ( .D(n_tetris_temp[21]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[21]), .QN(n2211) );
  DFFRX4 tetris_temp_reg_3__4_ ( .D(n_tetris_temp[64]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[64]), .QN(n2174) );
  DFFRX4 tetris_temp_reg_3__1_ ( .D(n_tetris_temp[61]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[61]), .QN(n2171) );
  DFFRX4 tetris_temp_reg_11__0_ ( .D(n_tetris_temp[12]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[12]), .QN(n2213) );
  DFFRX4 tetris_temp_reg_9__1_ ( .D(n_tetris_temp[25]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[25]), .QN(n2203) );
  DFFRX4 tetris_temp_reg_9__4_ ( .D(n_tetris_temp[28]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[28]), .QN(n2206) );
  DFFRX4 tetris_temp_reg_11__5_ ( .D(n_tetris_temp[17]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[17]), .QN(n2218) );
  DFFRX4 tetris_temp_reg_11__4_ ( .D(n_tetris_temp[16]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[16]), .QN(n2217) );
  DFFRX4 tetris_temp_reg_11__3_ ( .D(n_tetris_temp[15]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[15]), .QN(n2216) );
  DFFRX4 tetris_temp_reg_11__1_ ( .D(n_tetris_temp[13]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[13]), .QN(n2214) );
  DFFRX4 tetris_temp_reg_11__2_ ( .D(n_tetris_temp[14]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[14]), .QN(n2215) );
  DFFRX4 tetris_temp_reg_6__4_ ( .D(n_tetris_temp[46]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[46]), .QN(n2190) );
  DFFRX4 tetris_temp_reg_10__1_ ( .D(n_tetris_temp[19]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[19]), .QN(n2209) );
  DFFRX4 tetris_temp_reg_7__5_ ( .D(n_tetris_temp[41]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[41]), .QN(n2196) );
  DFFRX4 tetris_temp_reg_10__4_ ( .D(n_tetris_temp[22]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[22]) );
  DFFRX4 tetris_temp_reg_10__5_ ( .D(n_tetris_temp[23]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[23]), .QN(n2212) );
  DFFRX4 tetris_temp_reg_3__5_ ( .D(n_tetris_temp[65]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[65]), .QN(n2175) );
  DFFRX4 tetris_temp_reg_8__5_ ( .D(n_tetris_temp[35]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[35]), .QN(n2201) );
  DFFRX4 tetris_temp_reg_8__4_ ( .D(n_tetris_temp[34]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[34]), .QN(n2200) );
  DFFRX4 tetris_temp_reg_8__2_ ( .D(n_tetris_temp[32]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[32]), .QN(n2198) );
  DFFRX1 tetris_temp_reg_5__5_ ( .D(n_tetris_temp[53]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[53]), .QN(n2185) );
  DFFRX1 tetris_temp_reg_5__1_ ( .D(n_tetris_temp[49]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[49]), .QN(n2181) );
  DFFRX1 tetris_temp_reg_5__3_ ( .D(n_tetris_temp[51]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[51]), .QN(n2183) );
  DFFRX1 tetris_temp_reg_5__2_ ( .D(n_tetris_temp[50]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[50]), .QN(n2182) );
  DFFRX1 tetris_temp_reg_5__4_ ( .D(n_tetris_temp[52]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[52]), .QN(n2184) );
  DFFRHQX4 tetris_temp_reg_3__0_ ( .D(n_tetris_temp[60]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[60]) );
  DFFRX1 tetris_temp_reg_7__3_ ( .D(n_tetris_temp[39]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[39]), .QN(n2194) );
  DFFRHQXL tetris_temp_reg_1__1_ ( .D(n_tetris_temp[73]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[73]) );
  DFFRX1 tetris_temp_reg_7__4_ ( .D(n_tetris_temp[40]), .CK(clk), .RN(rst_n), 
        .Q(tetris_temp[40]), .QN(n2195) );
  DFFRX1 tetris_temp_reg_4__3_ ( .D(n_tetris_temp[57]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[57]), .QN(n2178) );
  DFFRX1 tetris_temp_reg_3__3_ ( .D(n_tetris_temp[63]), .CK(clk), .RN(rst_n), 
        .Q(tetris_temp[63]), .QN(n2173) );
  DFFRX1 tetris_temp_reg_6__5_ ( .D(n_tetris_temp[47]), .CK(clk), .RN(rst_n), 
        .Q(tetris_temp[47]), .QN(n2191) );
  DFFRX1 tetris_temp_reg_12__3_ ( .D(n_tetris_temp[9]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[9]) );
  DFFRX1 tetris_temp_reg_9__5_ ( .D(n_tetris_temp[29]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[29]), .QN(n2207) );
  DFFRX1 tetris_temp_reg_2__4_ ( .D(n_tetris_temp[70]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[70]), .QN(n2169) );
  DFFRX1 tetris_temp_reg_0__0_ ( .D(n_tetris_temp[78]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[78]), .QN(n2166) );
  DFFRX1 tetris_temp_reg_12__2_ ( .D(n_tetris_temp[8]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[8]) );
  DFFRX1 tetris_temp_reg_6__1_ ( .D(n_tetris_temp[43]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[43]), .QN(n2187) );
  DFFRX1 tetris_temp_reg_8__3_ ( .D(n_tetris_temp[33]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[33]), .QN(n2199) );
  DFFRX1 tetris_temp_reg_4__1_ ( .D(n_tetris_temp[55]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[55]), .QN(n2176) );
  DFFRX1 tetris_temp_reg_4__2_ ( .D(n_tetris_temp[56]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[56]), .QN(n2177) );
  DFFRX1 tetris_temp_reg_9__0_ ( .D(n_tetris_temp[24]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[24]), .QN(n2202) );
  DFFRX1 tetris_temp_reg_4__5_ ( .D(n_tetris_temp[59]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[59]), .QN(n2180) );
  DFFRX1 tetris_temp_reg_4__4_ ( .D(n_tetris_temp[58]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[58]), .QN(n2179) );
  DFFRX1 tetris_temp_reg_7__1_ ( .D(n_tetris_temp[37]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[37]), .QN(n2192) );
  DFFRX1 tetris_temp_reg_7__2_ ( .D(n_tetris_temp[38]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[38]), .QN(n2193) );
  DFFRX1 tetris_temp_reg_9__3_ ( .D(n_tetris_temp[27]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[27]), .QN(n2205) );
  DFFRX1 tetris_temp_reg_9__2_ ( .D(n_tetris_temp[26]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[26]), .QN(n2204) );
  DFFRX1 tetris_temp_reg_2__5_ ( .D(n_tetris_temp[71]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[71]), .QN(n2170) );
  DFFRX1 tetris_temp_reg_2__1_ ( .D(n_tetris_temp[67]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[67]), .QN(n2167) );
  DFFRX1 tetris_temp_reg_2__2_ ( .D(n_tetris_temp[68]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[68]), .QN(n2168) );
  DFFRX1 tetris_temp_reg_3__2_ ( .D(n_tetris_temp[62]), .CK(clk), .RN(n989), 
        .Q(tetris_temp[62]), .QN(n2172) );
  BUFXL U1163 ( .A(n1823), .Y(n1890) );
  NAND2BXL U1164 ( .AN(n1966), .B(n1965), .Y(n1967) );
  OAI211XL U1165 ( .A0(n1811), .A1(n1923), .B0(n1810), .C0(n1809), .Y(n1812)
         );
  OAI211XL U1166 ( .A0(n1811), .A1(n1917), .B0(n1788), .C0(n1787), .Y(n1789)
         );
  BUFX2 U1167 ( .A(n2026), .Y(n1038) );
  NAND2X2 U1168 ( .A(n1653), .B(n1652), .Y(n2114) );
  OAI2BB1XL U1169 ( .A0N(n1653), .A1N(n1433), .B0(n1496), .Y(n1434) );
  NAND2BX2 U1170 ( .AN(n1599), .B(n1034), .Y(n1033) );
  BUFX3 U1171 ( .A(n1770), .Y(n2092) );
  INVX1 U1172 ( .A(n1439), .Y(n1783) );
  NOR2X1 U1173 ( .A(n1607), .B(n1037), .Y(n1964) );
  NOR2X1 U1174 ( .A(n1961), .B(n1769), .Y(n1648) );
  BUFX4 U1175 ( .A(n1609), .Y(n2121) );
  BUFX2 U1176 ( .A(n1612), .Y(n1957) );
  NAND2X1 U1177 ( .A(n1652), .B(n2056), .Y(n1607) );
  INVX2 U1178 ( .A(n1960), .Y(n1652) );
  NOR2X2 U1179 ( .A(n1647), .B(n1649), .Y(n1808) );
  NOR2X1 U1180 ( .A(n2056), .B(n1580), .Y(n2053) );
  INVX2 U1181 ( .A(n1649), .Y(n2005) );
  INVX2 U1182 ( .A(n1017), .Y(n1018) );
  INVX2 U1183 ( .A(in_valid), .Y(n1017) );
  INVX2 U1184 ( .A(n1358), .Y(n1058) );
  NOR2BXL U1185 ( .AN(c_state[0]), .B(c_state[1]), .Y(n1100) );
  AND2X1 U1186 ( .A(n1518), .B(n1099), .Y(n1636) );
  NAND2X1 U1187 ( .A(n1514), .B(n1513), .Y(n2009) );
  INVX2 U1188 ( .A(n1273), .Y(n1207) );
  OAI21X2 U1189 ( .A0(n1739), .A1(n2213), .B0(n1260), .Y(n1261) );
  INVX2 U1190 ( .A(n1469), .Y(n1557) );
  NAND2X1 U1191 ( .A(n1437), .B(n1337), .Y(n1173) );
  NAND2X1 U1192 ( .A(n1148), .B(n1335), .Y(n1174) );
  NAND2X1 U1193 ( .A(n1253), .B(n1316), .Y(n1255) );
  NAND2X2 U1194 ( .A(n1237), .B(n992), .Y(n1332) );
  INVX2 U1195 ( .A(n1302), .Y(n1385) );
  INVX2 U1196 ( .A(n1204), .Y(n1241) );
  INVX4 U1197 ( .A(tetrominoes[1]), .Y(n1457) );
  AND2X2 U1198 ( .A(position[0]), .B(n1319), .Y(n1070) );
  INVX4 U1199 ( .A(position[0]), .Y(n1169) );
  CLKINVX2 U1200 ( .A(position[1]), .Y(n1019) );
  NOR2XL U1201 ( .A(tetris_temp[72]), .B(n2166), .Y(n1214) );
  NOR2XL U1202 ( .A(tetris_temp[55]), .B(tetris_temp[61]), .Y(n1163) );
  NOR2XL U1203 ( .A(tetris_temp[56]), .B(tetris_temp[62]), .Y(n1158) );
  NOR2XL U1204 ( .A(tetris_temp[50]), .B(tetris_temp[44]), .Y(n1160) );
  NOR2XL U1205 ( .A(n1129), .B(n1128), .Y(n1130) );
  NOR2XL U1206 ( .A(n1374), .B(n1370), .Y(n1371) );
  NOR2XL U1207 ( .A(n1092), .B(n1091), .Y(n1093) );
  INVXL U1208 ( .A(n1556), .Y(n1450) );
  NOR2XL U1209 ( .A(n1517), .B(n1093), .Y(n1512) );
  NOR2XL U1210 ( .A(n1532), .B(n1017), .Y(n1447) );
  NOR2XL U1211 ( .A(n1078), .B(n1077), .Y(n1526) );
  NOR2XL U1212 ( .A(n1095), .B(n1094), .Y(n1096) );
  NOR2XL U1213 ( .A(n1748), .B(n1747), .Y(n1764) );
  NOR2XL U1214 ( .A(tetris_temp[8]), .B(tetris_temp[7]), .Y(n1101) );
  NOR2XL U1215 ( .A(n1038), .B(n2140), .Y(n1969) );
  NOR2XL U1216 ( .A(n1860), .B(n1874), .Y(n1857) );
  NOR2XL U1217 ( .A(n1819), .B(n2116), .Y(n1806) );
  INVX2 U1218 ( .A(n1500), .Y(n990) );
  NOR2XL U1219 ( .A(n1553), .B(n1505), .Y(n2013) );
  NOR2X2 U1220 ( .A(n1000), .B(n1967), .Y(n2033) );
  NOR2XL U1221 ( .A(n1623), .B(score_temp[1]), .Y(n1624) );
  INVXL U1222 ( .A(n1991), .Y(n2129) );
  AND2X1 U1223 ( .A(n2081), .B(n1597), .Y(n988) );
  INVXL U1224 ( .A(tetris_temp[66]), .Y(n997) );
  OAI2BB1XL U1225 ( .A0N(n2040), .A1N(n1956), .B0(n1642), .Y(n_tetris_temp[7])
         );
  OAI2BB1XL U1226 ( .A0N(n2129), .A1N(n1956), .B0(n1943), .Y(n_tetris_temp[10]) );
  OAI2BB1XL U1227 ( .A0N(n2018), .A1N(n1956), .B0(n1646), .Y(n_tetris_temp[11]) );
  NOR2X1 U1228 ( .A(n1892), .B(n2116), .Y(n1871) );
  OAI2BB1XL U1229 ( .A0N(n2006), .A1N(n1951), .B0(n1950), .Y(n1952) );
  OAI2BB1XL U1230 ( .A0N(n2047), .A1N(n1951), .B0(n1721), .Y(n1722) );
  OAI2BB1XL U1231 ( .A0N(n2039), .A1N(n1951), .B0(n1639), .Y(n1640) );
  OAI2BB1XL U1232 ( .A0N(n2100), .A1N(n1951), .B0(n1940), .Y(n1941) );
  OAI2BB1XL U1233 ( .A0N(n2017), .A1N(n1951), .B0(n1643), .Y(n1644) );
  INVX1 U1234 ( .A(n1494), .Y(n1496) );
  NOR2X1 U1235 ( .A(n1748), .B(n2009), .Y(n1614) );
  INVX2 U1236 ( .A(n1365), .Y(n1367) );
  INVX8 U1237 ( .A(tetris_valid), .Y(n2160) );
  INVX8 U1238 ( .A(n1107), .Y(tetris_valid) );
  INVX1 U1239 ( .A(n1404), .Y(n1419) );
  INVX2 U1240 ( .A(n1587), .Y(n1747) );
  INVX1 U1241 ( .A(n2047), .Y(n2136) );
  INVX1 U1242 ( .A(n2006), .Y(n1999) );
  INVX2 U1243 ( .A(n1636), .Y(n1637) );
  INVX1 U1244 ( .A(n2126), .Y(n1874) );
  INVX2 U1245 ( .A(n1985), .Y(n2122) );
  INVX2 U1246 ( .A(n1978), .Y(n2021) );
  INVX2 U1247 ( .A(n1973), .Y(n2130) );
  AOI2BB1XL U1248 ( .A0N(n1522), .A1N(n1521), .B0(n1520), .Y(n1524) );
  NAND2X1 U1249 ( .A(n1505), .B(n1504), .Y(n1560) );
  INVX1 U1250 ( .A(n2019), .Y(n1917) );
  INVX2 U1251 ( .A(n1998), .Y(n2007) );
  OAI21X1 U1252 ( .A0(n1083), .A1(n1082), .B0(n1519), .Y(n1084) );
  INVX2 U1253 ( .A(n2032), .Y(n2040) );
  INVX2 U1254 ( .A(n2053), .Y(n1662) );
  INVX2 U1255 ( .A(n1189), .Y(n1309) );
  NAND3X1 U1256 ( .A(n1162), .B(n1109), .C(n2215), .Y(n1184) );
  NAND4BX1 U1257 ( .AN(n1086), .B(n1085), .C(tetris_temp[42]), .D(
        tetris_temp[44]), .Y(n1509) );
  NAND2X1 U1258 ( .A(n1102), .B(n1101), .Y(n1104) );
  NAND4X1 U1259 ( .A(tetris_temp[41]), .B(tetris_temp[39]), .C(tetris_temp[38]), .D(tetris_temp[37]), .Y(n1088) );
  NAND4XL U1260 ( .A(tetris_temp[77]), .B(tetris_temp[75]), .C(tetris_temp[74]), .D(tetris_temp[73]), .Y(n1076) );
  NOR2X1 U1261 ( .A(tetris_temp[52]), .B(tetris_temp[46]), .Y(n1145) );
  NOR2X1 U1262 ( .A(tetris_temp[47]), .B(tetris_temp[53]), .Y(n1155) );
  CLKINVX2 U1263 ( .A(n1621), .Y(n989) );
  OAI211XL U1264 ( .A0(n2113), .A1(n1786), .B0(n1780), .C0(n1779), .Y(
        n_tetris_temp[24]) );
  OAI211XL U1265 ( .A0(n1900), .A1(n2093), .B0(n1773), .C0(n1772), .Y(
        n_tetris_temp[30]) );
  OAI211XL U1266 ( .A0(n1923), .A1(n1890), .B0(n1606), .C0(n1605), .Y(
        n_tetris_temp[19]) );
  OAI211XL U1267 ( .A0(n2141), .A1(n2025), .B0(n1585), .C0(n1584), .Y(
        n_tetris_temp[1]) );
  OAI2BB1XL U1268 ( .A0N(n2130), .A1N(n1822), .B0(n1797), .Y(n_tetris_temp[15]) );
  OAI2BB1XL U1269 ( .A0N(n2130), .A1N(n1956), .B0(n1724), .Y(n_tetris_temp[9])
         );
  OAI2BB1XL U1270 ( .A0N(n1572), .A1N(n988), .B0(n1571), .Y(n_tetris_temp[69])
         );
  OAI2BB1XL U1271 ( .A0N(n2019), .A1N(n988), .B0(n1576), .Y(n_tetris_temp[71])
         );
  NAND4BXL U1272 ( .AN(n2080), .B(n2079), .C(n2078), .D(n2077), .Y(
        n_tetris_temp[54]) );
  OAI2BB1XL U1273 ( .A0N(n2040), .A1N(n2128), .B0(n2038), .Y(n_tetris_temp[73]) );
  OAI2BB1XL U1274 ( .A0N(n2126), .A1N(n988), .B0(n1702), .Y(n_tetris_temp[70])
         );
  OAI2BB1XL U1275 ( .A0N(n1551), .A1N(n988), .B0(n1550), .Y(n_tetris_temp[68])
         );
  AOI2BB1XL U1276 ( .A0N(n2098), .A1N(n2114), .B0(n2097), .Y(n2099) );
  INVX3 U1277 ( .A(n1823), .Y(n1891) );
  NOR2X1 U1278 ( .A(n1819), .B(n2052), .Y(n1796) );
  NOR2X1 U1279 ( .A(n1918), .B(n1066), .Y(n1065) );
  NOR2X1 U1280 ( .A(n2059), .B(n2069), .Y(n2063) );
  NOR2X1 U1281 ( .A(n1038), .B(n2025), .Y(n2028) );
  NOR2X1 U1282 ( .A(n1038), .B(n1985), .Y(n1987) );
  NOR2X1 U1283 ( .A(n1038), .B(n1992), .Y(n1994) );
  NOR2X1 U1284 ( .A(n1038), .B(n1978), .Y(n1980) );
  NOR2X1 U1285 ( .A(n1957), .B(n2053), .Y(n1000) );
  NOR2X1 U1286 ( .A(n1984), .B(n1908), .Y(n1463) );
  INVXL U1287 ( .A(n1745), .Y(n1598) );
  NOR2X1 U1288 ( .A(n1494), .B(n1662), .Y(n1908) );
  AOI22XL U1289 ( .A0(tetris_temp[48]), .A1(n2075), .B0(n2074), .B1(
        tetris_temp[54]), .Y(n2078) );
  INVX1 U1290 ( .A(n1654), .Y(n2119) );
  NOR2X1 U1291 ( .A(n1960), .B(n1209), .Y(n1494) );
  OR2XL U1292 ( .A(n1544), .B(n1586), .Y(n1654) );
  OR2XL U1293 ( .A(n1764), .B(n1018), .Y(n1921) );
  INVX1 U1294 ( .A(n1748), .Y(n1765) );
  NOR2X1 U1295 ( .A(n1018), .B(n2011), .Y(n2108) );
  NOR2X1 U1296 ( .A(n1018), .B(n1546), .Y(n1655) );
  NOR2X1 U1297 ( .A(tetris_valid), .B(n1545), .Y(n1546) );
  NOR2X1 U1298 ( .A(n1622), .B(n1631), .Y(n1623) );
  NOR2X1 U1299 ( .A(n1378), .B(n1556), .Y(n1352) );
  NOR2X1 U1300 ( .A(n1763), .B(n1586), .Y(n2010) );
  NAND4X1 U1301 ( .A(n1323), .B(n1320), .C(n1321), .D(n1322), .Y(n1324) );
  INVX1 U1302 ( .A(n2115), .Y(n2100) );
  AOI2BB2XL U1303 ( .B0(n1201), .B1(n1303), .A0N(tetris_temp[15]), .A1N(n1200), 
        .Y(n1348) );
  INVX3 U1304 ( .A(n1122), .Y(n1123) );
  NAND2X1 U1305 ( .A(n1536), .B(n1535), .Y(n2006) );
  NOR2X1 U1306 ( .A(n1568), .B(n1567), .Y(n2052) );
  INVX1 U1307 ( .A(n1944), .Y(n1551) );
  NAND2X1 U1308 ( .A(n1562), .B(n1561), .Y(n2047) );
  NOR2X1 U1309 ( .A(n1518), .B(n1517), .Y(n1527) );
  INVX1 U1310 ( .A(n1258), .Y(n1317) );
  NAND2X1 U1311 ( .A(n1560), .B(n1552), .Y(n1944) );
  NOR2X1 U1312 ( .A(n1484), .B(n1483), .Y(n2046) );
  NOR2X1 U1313 ( .A(n1476), .B(n1738), .Y(n2126) );
  OAI21XL U1314 ( .A0(n1218), .A1(tetris_temp[12]), .B0(n1217), .Y(n1219) );
  NOR2X1 U1315 ( .A(n1097), .B(n1096), .Y(n1518) );
  OAI21XL U1316 ( .A0(n1147), .A1(tetris_temp[16]), .B0(n1146), .Y(n1335) );
  NAND2X1 U1317 ( .A(n1041), .B(n1307), .Y(n1044) );
  NOR2X1 U1318 ( .A(n1991), .B(n1566), .Y(n1444) );
  NAND2X1 U1319 ( .A(n1467), .B(n1018), .Y(n1973) );
  INVX1 U1320 ( .A(n2133), .Y(n1572) );
  NOR2X1 U1321 ( .A(n1553), .B(n1504), .Y(n2049) );
  NOR2X1 U1322 ( .A(n1998), .B(n1566), .Y(n1567) );
  NOR2X1 U1323 ( .A(n1468), .B(n1467), .Y(n1476) );
  AOI2BB2XL U1324 ( .B0(n1737), .B1(n1563), .A0N(n1556), .A1N(n1472), .Y(n1473) );
  INVX1 U1325 ( .A(n1923), .Y(n2041) );
  INVX1 U1326 ( .A(n1303), .Y(n1307) );
  AOI2BB1XL U1327 ( .A0N(n1187), .A1N(tetris_temp[52]), .B0(tetris_temp[46]), 
        .Y(n1190) );
  INVX1 U1328 ( .A(n1512), .Y(n1097) );
  NAND2X1 U1329 ( .A(n1552), .B(n1481), .Y(n1923) );
  INVX1 U1330 ( .A(n2018), .Y(n1984) );
  NAND2X1 U1331 ( .A(n1468), .B(n1018), .Y(n1991) );
  NOR2X1 U1332 ( .A(n1738), .B(n1446), .Y(n2019) );
  NAND2X1 U1333 ( .A(n1018), .B(n1499), .Y(n1998) );
  NAND2X1 U1334 ( .A(n1552), .B(n1563), .Y(n2133) );
  INVX1 U1335 ( .A(n2094), .Y(n2093) );
  NOR2X1 U1336 ( .A(n1104), .B(n1103), .Y(n1632) );
  NOR2X1 U1337 ( .A(n1111), .B(n1140), .Y(n1303) );
  INVX1 U1338 ( .A(n1449), .Y(n1563) );
  NOR2X1 U1339 ( .A(n1580), .B(n1782), .Y(n2086) );
  INVX1 U1340 ( .A(n2105), .Y(n2085) );
  INVX1 U1341 ( .A(n1501), .Y(n1505) );
  INVX1 U1342 ( .A(n1738), .Y(n1552) );
  NAND2X1 U1343 ( .A(n1501), .B(n1018), .Y(n2032) );
  NAND3BX1 U1344 ( .AN(n1098), .B(tetris_temp[15]), .C(tetris_temp[13]), .Y(
        n1099) );
  NOR2X1 U1345 ( .A(n1072), .B(n1071), .Y(n1522) );
  NOR2X1 U1346 ( .A(n1112), .B(n1152), .Y(n1301) );
  NOR2X1 U1347 ( .A(n1090), .B(n1089), .Y(n1517) );
  NAND3X1 U1348 ( .A(n1147), .B(n1108), .C(n2217), .Y(n1189) );
  AOI2BB1XL U1349 ( .A0N(n2146), .A1N(tetris_temp[77]), .B0(tetris_temp[71]), 
        .Y(n1180) );
  NOR2X1 U1350 ( .A(n1088), .B(n1087), .Y(n1510) );
  NOR2X1 U1351 ( .A(n1076), .B(n1075), .Y(n1523) );
  NOR2X1 U1352 ( .A(n1466), .B(tetrominoes[0]), .Y(n1580) );
  INVX1 U1353 ( .A(n1931), .Y(n1782) );
  NOR2X1 U1354 ( .A(tetris_temp[48]), .B(tetris_temp[42]), .Y(n1243) );
  NOR2X1 U1355 ( .A(tetris_temp[30]), .B(tetris_temp[36]), .Y(n1231) );
  NOR2X1 U1356 ( .A(tetris_temp[28]), .B(tetris_temp[22]), .Y(n1147) );
  NOR2X1 U1357 ( .A(tetris_temp[34]), .B(tetris_temp[40]), .Y(n1108) );
  NOR2X1 U1358 ( .A(tetris_temp[57]), .B(tetris_temp[63]), .Y(n1138) );
  NOR2X1 U1359 ( .A(tetris_temp[33]), .B(tetris_temp[39]), .Y(n1110) );
  NOR2X1 U1360 ( .A(tetris_temp[49]), .B(tetris_temp[43]), .Y(n1166) );
  NOR2X1 U1361 ( .A(tetris_temp[51]), .B(tetris_temp[45]), .Y(n1139) );
  NOR2X1 U1362 ( .A(tetris_temp[20]), .B(tetris_temp[26]), .Y(n1162) );
  NOR2X1 U1363 ( .A(tetris_temp[32]), .B(tetris_temp[38]), .Y(n1109) );
  NOR2X1 U1364 ( .A(tetris_temp[25]), .B(tetris_temp[19]), .Y(n1168) );
  NOR2X1 U1365 ( .A(tetris_temp[31]), .B(tetris_temp[37]), .Y(n1113) );
  NOR2X1 U1366 ( .A(tetris_temp[30]), .B(tetris_temp[12]), .Y(n1228) );
  NOR2X1 U1367 ( .A(tetris_temp[6]), .B(tetris_temp[9]), .Y(n1102) );
  AOI2BB1XL U1368 ( .A0N(tetris_temp[71]), .A1N(tetris_temp[77]), .B0(
        tetris_temp[59]), .Y(n1150) );
  NOR2X1 U1369 ( .A(n1017), .B(position[2]), .Y(n1558) );
  NAND2X2 U1370 ( .A(n1457), .B(tetrominoes[0]), .Y(n1931) );
  INVX4 U1371 ( .A(n1019), .Y(n1020) );
  INVX4 U1372 ( .A(n1015), .Y(n991) );
  INVX8 U1373 ( .A(n1016), .Y(n992) );
  INVXL U1374 ( .A(1'b1), .Y(score[3]) );
  INVX8 U1376 ( .A(position[2]), .Y(n1470) );
  NAND3X2 U1377 ( .A(n1426), .B(n1421), .C(n1058), .Y(n995) );
  NAND3X2 U1378 ( .A(n1426), .B(n1421), .C(n1058), .Y(n1377) );
  OAI21X2 U1379 ( .A0(n1272), .A1(n1466), .B0(n1205), .Y(n1206) );
  MXI2X1 U1380 ( .A(n1372), .B(n1371), .S0(n1055), .Y(n1376) );
  INVX2 U1381 ( .A(n1442), .Y(n1446) );
  NAND2X2 U1382 ( .A(n1441), .B(n1440), .Y(n1305) );
  NAND2X4 U1383 ( .A(n1241), .B(tetrominoes[0]), .Y(n1441) );
  NOR2X1 U1384 ( .A(n1441), .B(n1017), .Y(n1564) );
  AOI2BB2X1 U1385 ( .B0(n1437), .B1(n1308), .A0N(n1739), .A1N(n1164), .Y(n1114) );
  NOR2X1 U1386 ( .A(n1860), .B(n1923), .Y(n1866) );
  NAND2BX4 U1387 ( .AN(n1036), .B(n990), .Y(n1892) );
  INVXL U1388 ( .A(n2117), .Y(n996) );
  OAI22XL U1389 ( .A0(n1786), .A1(n2052), .B0(n2136), .B1(n1892), .Y(n1669) );
  OAI22X1 U1390 ( .A0(n1303), .A1(n1302), .B0(n1301), .B1(n1268), .Y(n1269) );
  NOR2X1 U1391 ( .A(n1287), .B(n1290), .Y(n1288) );
  MXI2X4 U1392 ( .A(n1202), .B(n1348), .S0(position[1]), .Y(n1211) );
  INVX2 U1393 ( .A(n1499), .Y(n1503) );
  NAND2X1 U1394 ( .A(n1052), .B(n1353), .Y(n1048) );
  NAND2X1 U1395 ( .A(n1226), .B(n991), .Y(n1240) );
  NAND2X2 U1396 ( .A(n1499), .B(n1317), .Y(n1028) );
  OAI31X1 U1397 ( .A0(n1909), .A1(n1908), .A2(n2085), .B0(n1743), .Y(
        n_tetris_temp[60]) );
  NAND2X2 U1398 ( .A(n1246), .B(n1221), .Y(n1222) );
  AOI2BB2X4 U1399 ( .B0(n1192), .B1(n1442), .A0N(n1191), .A1N(n1248), .Y(n1273) );
  NOR2X2 U1400 ( .A(n991), .B(n1347), .Y(n1192) );
  INVX2 U1401 ( .A(n1368), .Y(n1052) );
  NAND2X4 U1402 ( .A(n991), .B(position[2]), .Y(n1268) );
  NAND2X2 U1403 ( .A(n1373), .B(n1533), .Y(n1368) );
  AND2X4 U1404 ( .A(n1423), .B(n1432), .Y(n1007) );
  OAI2BB1X2 U1405 ( .A0N(n1266), .A1N(n1265), .B0(n1264), .Y(n1271) );
  NAND2X2 U1406 ( .A(n1240), .B(n1239), .Y(n1403) );
  NOR2X1 U1407 ( .A(n1523), .B(n1526), .Y(n1513) );
  NOR2X1 U1408 ( .A(n1522), .B(n1520), .Y(n1514) );
  OR2X1 U1409 ( .A(n2026), .B(n1931), .Y(n1069) );
  INVX4 U1410 ( .A(n2026), .Y(n1910) );
  NOR2X2 U1411 ( .A(n1422), .B(n1393), .Y(n1363) );
  NOR2X1 U1412 ( .A(n1289), .B(n1288), .Y(n1294) );
  AOI2BB2X4 U1413 ( .B0(n1385), .B1(n1317), .A0N(n1268), .A1N(n1259), .Y(n1260) );
  NAND2X2 U1414 ( .A(n1480), .B(n1070), .Y(n1134) );
  OAI211XL U1415 ( .A0(n1919), .A1(n2052), .B0(n1851), .C0(n1850), .Y(n1852)
         );
  NOR2X1 U1416 ( .A(n1860), .B(n1917), .Y(n1839) );
  NAND2X2 U1417 ( .A(position[0]), .B(position[1]), .Y(n1302) );
  NAND2X1 U1418 ( .A(n1338), .B(position[0]), .Y(n1171) );
  OAI211XL U1419 ( .A0(n2046), .A1(n1919), .B0(n1864), .C0(n1863), .Y(n1865)
         );
  AOI2BB1XL U1420 ( .A0N(n1214), .A1N(tetris_temp[66]), .B0(tetris_temp[60]), 
        .Y(n1216) );
  NOR2X1 U1421 ( .A(n2164), .B(n1631), .Y(score[0]) );
  AOI21X1 U1422 ( .A0(n1555), .A1(n1475), .B0(n1474), .Y(n2115) );
  INVX2 U1423 ( .A(n1448), .Y(n1116) );
  INVX8 U1424 ( .A(tetris_valid), .Y(n998) );
  NOR2X1 U1425 ( .A(n1632), .B(n2164), .Y(fail) );
  INVX2 U1426 ( .A(score_valid), .Y(n2164) );
  NAND3X4 U1427 ( .A(n1456), .B(n1455), .C(tetrominoes[1]), .Y(n1556) );
  INVX8 U1428 ( .A(tetrominoes[2]), .Y(n1456) );
  NAND2XL U1429 ( .A(n2205), .B(n2211), .Y(n1140) );
  BUFX1 U1430 ( .A(n1448), .Y(n1467) );
  OAI2BB1X1 U1431 ( .A0N(n1225), .A1N(n1235), .B0(n1224), .Y(n1226) );
  NAND2XL U1432 ( .A(n1557), .B(n1336), .Y(n1056) );
  OAI21XL U1433 ( .A0(tetris_temp[47]), .A1(n1120), .B0(n1301), .Y(n1176) );
  NOR2XL U1434 ( .A(n2180), .B(tetris_temp[53]), .Y(n1120) );
  NAND2XL U1435 ( .A(n2212), .B(n2207), .Y(n1152) );
  OAI21X2 U1436 ( .A0(n1135), .A1(n1469), .B0(n1134), .Y(n1031) );
  NAND2XL U1437 ( .A(n1470), .B(n1249), .Y(n1135) );
  NAND2XL U1438 ( .A(n1274), .B(n1466), .Y(n1397) );
  INVXL U1439 ( .A(n1184), .Y(n1304) );
  NAND2XL U1440 ( .A(n1110), .B(n2216), .Y(n1111) );
  NAND3BXL U1441 ( .AN(tetris_temp[41]), .B(n2218), .C(n2201), .Y(n1112) );
  NAND4XL U1442 ( .A(n1402), .B(n1411), .C(n1410), .D(n1409), .Y(n1417) );
  OAI2BB1X1 U1443 ( .A0N(n1406), .A1N(n1279), .B0(n1404), .Y(n1411) );
  NAND2XL U1444 ( .A(n1413), .B(n1405), .Y(n1410) );
  NAND2XL U1445 ( .A(tetris_temp[43]), .B(tetris_temp[45]), .Y(n1086) );
  AND2XL U1446 ( .A(tetris_temp[47]), .B(tetris_temp[46]), .Y(n1085) );
  NAND4XL U1447 ( .A(tetris_temp[59]), .B(tetris_temp[58]), .C(tetris_temp[56]), .D(tetris_temp[55]), .Y(n1083) );
  NAND2XL U1448 ( .A(tetris_temp[57]), .B(tetris_temp[54]), .Y(n1082) );
  NAND2XL U1449 ( .A(tetris_temp[29]), .B(tetris_temp[24]), .Y(n1089) );
  NAND4XL U1450 ( .A(tetris_temp[27]), .B(tetris_temp[28]), .C(tetris_temp[26]), .D(tetris_temp[25]), .Y(n1090) );
  INVXL U1451 ( .A(n2086), .Y(n1768) );
  INVXL U1452 ( .A(n1776), .Y(n1684) );
  OAI21XL U1453 ( .A0(n1544), .A1(n1763), .B0(n1654), .Y(n2083) );
  NAND2XL U1454 ( .A(n1485), .B(n1018), .Y(n1553) );
  INVXL U1455 ( .A(n1775), .Y(n1762) );
  NOR2XL U1456 ( .A(n1892), .B(n2016), .Y(n1830) );
  OAI22XL U1457 ( .A0(n2068), .A1(n2024), .B0(n1915), .B1(n1901), .Y(n1461) );
  INVXL U1458 ( .A(n2024), .Y(n1981) );
  OAI21XL U1459 ( .A0(n1973), .A1(n1440), .B0(n1565), .Y(n1568) );
  NAND2XL U1460 ( .A(n2119), .B(n2008), .Y(n2107) );
  AOI22XL U1461 ( .A0(n1560), .A1(n1564), .B0(n1559), .B1(n1558), .Y(n1561) );
  NAND2XL U1462 ( .A(n1555), .B(n1563), .Y(n1562) );
  OAI21XL U1463 ( .A0(n1557), .A1(n1440), .B0(n1556), .Y(n1559) );
  NOR2XL U1464 ( .A(n1739), .B(n1017), .Y(n2105) );
  NAND2X1 U1465 ( .A(n2105), .B(n1737), .Y(n2113) );
  OAI21XL U1466 ( .A0(n1130), .A1(n1263), .B0(n2214), .Y(n1249) );
  INVXL U1467 ( .A(n1197), .Y(n1202) );
  OAI21XL U1468 ( .A0(n1168), .A1(tetris_temp[13]), .B0(n1167), .Y(n1225) );
  OAI21XL U1469 ( .A0(n1162), .A1(tetris_temp[14]), .B0(n1161), .Y(n1338) );
  NAND3XL U1470 ( .A(n1480), .B(n1247), .C(n1246), .Y(n1257) );
  AOI21XL U1471 ( .A0(n1244), .A1(n1243), .B0(n1265), .Y(n1247) );
  OAI2BB1XL U1472 ( .A0N(n1145), .A1N(n1144), .B0(n1309), .Y(n1146) );
  NAND2XL U1473 ( .A(n1157), .B(n1156), .Y(n1337) );
  AOI2BB1XL U1474 ( .A0N(n1308), .A1N(n1155), .B0(n1154), .Y(n1156) );
  OAI21XL U1475 ( .A0(n1307), .A1(n1142), .B0(n1141), .Y(n1336) );
  AOI2BB2XL U1476 ( .B0(n1140), .B1(n2216), .A0N(n1307), .A1N(n1139), .Y(n1141) );
  OAI21XL U1477 ( .A0(n1133), .A1(n1184), .B0(n2215), .Y(n1319) );
  NOR2X1 U1478 ( .A(n1132), .B(n1131), .Y(n1133) );
  NAND2XL U1479 ( .A(n1121), .B(n1176), .Y(n1318) );
  AOI2BB1XL U1480 ( .A0N(n1308), .A1N(n1149), .B0(tetris_temp[17]), .Y(n1121)
         );
  OAI21XL U1481 ( .A0(n1127), .A1(n1189), .B0(n2217), .Y(n1316) );
  NOR2X1 U1482 ( .A(n1126), .B(n1125), .Y(n1127) );
  AOI2BB1XL U1483 ( .A0N(n1119), .A1N(n1307), .B0(tetris_temp[15]), .Y(n1258)
         );
  NOR2X1 U1484 ( .A(n1118), .B(n1117), .Y(n1119) );
  OR2XL U1485 ( .A(n1469), .B(n1304), .Y(n1061) );
  AOI2BB1XL U1486 ( .A0N(n1180), .A1N(n1179), .B0(n1178), .Y(n1347) );
  OAI21XL U1487 ( .A0(tetris_temp[17]), .A1(n1177), .B0(n1176), .Y(n1178) );
  OAI22X1 U1488 ( .A0(n1190), .A1(n1189), .B0(tetris_temp[16]), .B1(n1188), 
        .Y(n1383) );
  AOI2BB1XL U1489 ( .A0N(n2200), .A1N(tetris_temp[28]), .B0(tetris_temp[22]), 
        .Y(n1188) );
  OAI22X1 U1490 ( .A0(n1185), .A1(n1184), .B0(tetris_temp[14]), .B1(n1183), 
        .Y(n1386) );
  AOI2BB1XL U1491 ( .A0N(n2198), .A1N(tetris_temp[26]), .B0(tetris_temp[20]), 
        .Y(n1183) );
  NAND2X1 U1492 ( .A(n1290), .B(n1291), .Y(n1293) );
  INVX2 U1493 ( .A(n1354), .Y(n1315) );
  OAI22XL U1494 ( .A0(n1304), .A1(n1332), .B0(n1267), .B1(n1309), .Y(n1270) );
  NAND4XL U1495 ( .A(tetris_temp[31]), .B(tetris_temp[32]), .C(tetris_temp[35]), .D(tetris_temp[34]), .Y(n1092) );
  NAND2XL U1496 ( .A(tetris_temp[33]), .B(tetris_temp[30]), .Y(n1091) );
  NAND2XL U1497 ( .A(tetris_temp[40]), .B(tetris_temp[36]), .Y(n1087) );
  INVXL U1498 ( .A(n1962), .Y(n1963) );
  AOI21XL U1499 ( .A0(n1017), .A1(n1530), .B0(n2060), .Y(n1861) );
  INVX2 U1500 ( .A(n1828), .Y(n1781) );
  AOI31XL U1501 ( .A0(n2008), .A1(n1017), .A2(n2009), .B0(n1655), .Y(n2082) );
  NAND4XL U1502 ( .A(n1457), .B(n1456), .C(n1455), .D(n1018), .Y(n1738) );
  NAND2XL U1503 ( .A(n1765), .B(n2009), .Y(n1544) );
  OAI22XL U1504 ( .A0(n1530), .A1(n1527), .B0(n1526), .B1(n1525), .Y(n1763) );
  NOR2XL U1505 ( .A(n1524), .B(n1523), .Y(n1525) );
  AND2X1 U1506 ( .A(n1769), .B(n1768), .Y(n1040) );
  NAND2XL U1507 ( .A(n2053), .B(n1487), .Y(n1736) );
  NOR2XL U1508 ( .A(n1486), .B(n1485), .Y(n1487) );
  NAND4XL U1509 ( .A(tetris_temp[12]), .B(tetris_temp[16]), .C(tetris_temp[14]), .D(tetris_temp[17]), .Y(n1098) );
  NAND2XL U1510 ( .A(n1765), .B(n1588), .Y(n1638) );
  NOR2X1 U1511 ( .A(n2008), .B(n1589), .Y(n1588) );
  AOI22XL U1512 ( .A0(n1862), .A1(tetris_temp[37]), .B0(n1861), .B1(
        tetris_temp[43]), .Y(n1863) );
  INVXL U1513 ( .A(n1882), .Y(n1875) );
  NOR2XL U1514 ( .A(n1892), .B(n2052), .Y(n1834) );
  INVX2 U1515 ( .A(n1498), .Y(n1869) );
  OR2XL U1516 ( .A(n1957), .B(n1931), .Y(n1495) );
  INVXL U1517 ( .A(n1608), .Y(n1497) );
  NAND2XL U1518 ( .A(n1458), .B(n1017), .Y(n1903) );
  INVXL U1519 ( .A(n1607), .Y(n1433) );
  NAND4X1 U1520 ( .A(n1507), .B(n1560), .C(n1506), .D(n1018), .Y(n2016) );
  NAND3XL U1521 ( .A(n1504), .B(n1566), .C(n1441), .Y(n1506) );
  NAND2XL U1522 ( .A(n1534), .B(n1533), .Y(n1535) );
  NAND2XL U1523 ( .A(n1555), .B(n1560), .Y(n1536) );
  OAI21XL U1524 ( .A0(n1998), .A1(n1532), .B0(n1531), .Y(n1534) );
  INVXL U1525 ( .A(n1655), .Y(n2118) );
  NAND2XL U1526 ( .A(n1649), .B(n1662), .Y(n1651) );
  INVXL U1527 ( .A(n2013), .Y(n1992) );
  AND2XL U1528 ( .A(n1623), .B(score_temp[1]), .Y(n1626) );
  AOI2BB2X1 U1529 ( .B0(n2129), .B1(n1737), .A0N(n1466), .A1N(n1973), .Y(n2116) );
  AOI2BB1XL U1530 ( .A0N(n1555), .A1N(n1447), .B0(n1446), .Y(n1454) );
  OAI211XL U1531 ( .A0(n1991), .A1(n1441), .B0(n1452), .C0(n1451), .Y(n1453)
         );
  NAND2XL U1532 ( .A(n1465), .B(n1468), .Y(n1978) );
  NAND2XL U1533 ( .A(n1017), .B(tetris_valid), .Y(n2132) );
  NAND2XL U1534 ( .A(n1465), .B(n1467), .Y(n1985) );
  OAI22XL U1535 ( .A0(n1473), .A1(n1017), .B0(n1532), .B1(n1991), .Y(n1474) );
  NOR2BX1 U1536 ( .AN(n1930), .B(n1581), .Y(n1582) );
  OAI21XL U1537 ( .A0(n1440), .A1(n1984), .B0(n1443), .Y(n1445) );
  NAND2XL U1538 ( .A(position[2]), .B(n1018), .Y(n1436) );
  INVX2 U1539 ( .A(n2117), .Y(n2102) );
  NAND2XL U1540 ( .A(n2105), .B(n2058), .Y(n2069) );
  NOR2XL U1541 ( .A(n1931), .B(n1456), .Y(n2056) );
  NOR2XL U1542 ( .A(n1748), .B(n1587), .Y(n1920) );
  NAND2XL U1543 ( .A(n1736), .B(n2105), .Y(n2098) );
  AOI21XL U1544 ( .A0(n1764), .A1(n1763), .B0(n1762), .Y(n1894) );
  AOI21XL U1545 ( .A0(n1765), .A1(n2010), .B0(n1920), .Y(n1893) );
  AND2XL U1546 ( .A(n2105), .B(n1580), .Y(n1483) );
  OAI21XL U1547 ( .A0(n2032), .A1(n1440), .B0(n1482), .Y(n1484) );
  INVXL U1548 ( .A(n2043), .Y(n2025) );
  OAI21XL U1549 ( .A0(n1441), .A1(n2085), .B0(n1489), .Y(n2039) );
  NAND2XL U1550 ( .A(n1736), .B(n1488), .Y(n1489) );
  INVXL U1551 ( .A(n1531), .Y(n1488) );
  OAI21XL U1552 ( .A0(n1638), .A1(n1637), .B0(n1017), .Y(n1948) );
  OAI21X1 U1553 ( .A0(n1636), .A1(n1638), .B0(n1875), .Y(n1949) );
  NAND2X1 U1554 ( .A(n1001), .B(n1634), .Y(n1956) );
  OR2X1 U1555 ( .A(n1597), .B(n1635), .Y(n1001) );
  OAI2BB1XL U1556 ( .A0N(n2130), .A1N(n1774), .B0(n1670), .Y(n_tetris_temp[27]) );
  OAI211XL U1557 ( .A0(n2114), .A1(n2113), .B0(n2112), .C0(n2111), .Y(
        n_tetris_temp[78]) );
  AOI22XL U1558 ( .A0(n2110), .A1(tetris_temp[72]), .B0(tetris_temp[78]), .B1(
        n2109), .Y(n2111) );
  NOR2X1 U1559 ( .A(n1153), .B(tetris_temp[17]), .Y(n1154) );
  NOR2XL U1560 ( .A(tetris_temp[53]), .B(tetris_temp[65]), .Y(n1149) );
  NOR2X1 U1561 ( .A(tetris_temp[58]), .B(tetris_temp[64]), .Y(n1143) );
  NAND2XL U1562 ( .A(n1301), .B(n1149), .Y(n1179) );
  INVX2 U1563 ( .A(n1346), .Y(n1051) );
  INVX2 U1564 ( .A(n1267), .Y(n1253) );
  NOR2XL U1565 ( .A(n1485), .B(n1241), .Y(n1287) );
  NAND2X1 U1566 ( .A(n1238), .B(n1246), .Y(n1239) );
  INVXL U1567 ( .A(n1318), .Y(n1259) );
  NAND2X1 U1568 ( .A(n1252), .B(n1251), .Y(n1256) );
  INVXL U1569 ( .A(n1248), .Y(n1252) );
  NOR2XL U1570 ( .A(n1250), .B(n1020), .Y(n1251) );
  INVXL U1571 ( .A(n1249), .Y(n1250) );
  NAND3X1 U1572 ( .A(n1246), .B(n1319), .C(n1020), .Y(n1254) );
  NAND3XL U1573 ( .A(n1168), .B(n1113), .C(n2214), .Y(n1263) );
  INVXL U1574 ( .A(n1220), .Y(n1021) );
  NAND2X1 U1575 ( .A(n1334), .B(n1450), .Y(n1353) );
  NAND2XL U1576 ( .A(n1379), .B(n1335), .Y(n1057) );
  NAND2XL U1577 ( .A(n1382), .B(n1335), .Y(n1342) );
  NAND2XL U1578 ( .A(n1557), .B(n1338), .Y(n1339) );
  INVXL U1579 ( .A(n1403), .Y(n1279) );
  NAND2X1 U1580 ( .A(n1501), .B(n1263), .Y(n1264) );
  INVXL U1581 ( .A(n1739), .Y(n1266) );
  NAND3XL U1582 ( .A(n1229), .B(n1228), .C(n2157), .Y(n1265) );
  NAND2X1 U1583 ( .A(n1557), .B(n1319), .Y(n1320) );
  NAND2XL U1584 ( .A(n1379), .B(n1317), .Y(n1322) );
  OR2XL U1585 ( .A(n1435), .B(n1303), .Y(n1062) );
  INVXL U1586 ( .A(n1328), .Y(n1344) );
  NOR2X1 U1587 ( .A(n1286), .B(n1406), .Y(n1296) );
  BUFXL U1588 ( .A(n1353), .Y(n1370) );
  NAND3XL U1589 ( .A(n1402), .B(n1415), .C(n1414), .Y(n1416) );
  NAND2XL U1590 ( .A(n1413), .B(n1412), .Y(n1415) );
  MXI2XL U1591 ( .A(n1401), .B(n1241), .S0(n1400), .Y(n1404) );
  OR2XL U1592 ( .A(n1398), .B(n1485), .Y(n1401) );
  INVXL U1593 ( .A(n1399), .Y(n1400) );
  NAND4BXL U1594 ( .AN(n1081), .B(n1080), .C(tetris_temp[51]), .D(
        tetris_temp[48]), .Y(n1519) );
  INVXL U1595 ( .A(n1079), .Y(n1080) );
  NAND2X1 U1596 ( .A(n1456), .B(tetrominoes[0]), .Y(n1274) );
  NAND4XL U1597 ( .A(tetris_temp[23]), .B(tetris_temp[22]), .C(tetris_temp[21]), .D(tetris_temp[20]), .Y(n1095) );
  OAI2BB1X1 U1598 ( .A0N(n1300), .A1N(n1355), .B0(n1405), .Y(n1008) );
  MXI2X2 U1599 ( .A(n1370), .B(n1368), .S0(n1005), .Y(n1361) );
  NAND4XL U1600 ( .A(n1390), .B(n1389), .C(n1388), .D(n1387), .Y(n1391) );
  AND2XL U1601 ( .A(n1378), .B(n1450), .Y(n1392) );
  BUFX2 U1602 ( .A(n1148), .Y(n1448) );
  NAND2X1 U1603 ( .A(n1508), .B(n1509), .Y(n1530) );
  OAI22XL U1604 ( .A0(n1516), .A1(n1515), .B0(n1514), .B1(n1545), .Y(n1586) );
  NOR2X2 U1605 ( .A(n1274), .B(n1457), .Y(n1485) );
  NAND2XL U1606 ( .A(n1440), .B(n1556), .Y(n1486) );
  NAND2XL U1607 ( .A(tetris_temp[19]), .B(tetris_temp[18]), .Y(n1094) );
  NOR2XL U1608 ( .A(n1587), .B(n1586), .Y(n1528) );
  NAND2XL U1609 ( .A(n1776), .B(n1590), .Y(n1882) );
  NAND2XL U1610 ( .A(n1638), .B(n1017), .Y(n1883) );
  BUFX1 U1611 ( .A(n1469), .Y(n1471) );
  INVXL U1612 ( .A(n1486), .Y(n1532) );
  INVXL U1613 ( .A(n1763), .Y(n2008) );
  NAND2X1 U1614 ( .A(n1017), .B(n2160), .Y(n1748) );
  NOR2X1 U1615 ( .A(n1530), .B(n1510), .Y(n1587) );
  INVXL U1616 ( .A(n1647), .Y(n1769) );
  NAND2XL U1617 ( .A(n1481), .B(n1018), .Y(n1531) );
  OR2XL U1618 ( .A(tetris_temp[11]), .B(tetris_temp[10]), .Y(n1103) );
  NOR2XL U1619 ( .A(n1892), .B(n2024), .Y(n1896) );
  NAND2XL U1620 ( .A(n1017), .B(n1589), .Y(n1776) );
  NAND2XL U1621 ( .A(n2132), .B(n1776), .Y(n1775) );
  INVXL U1622 ( .A(n2016), .Y(n1995) );
  INVXL U1623 ( .A(n2046), .Y(n2029) );
  AOI21XL U1624 ( .A0(n1614), .A1(n1528), .B0(n2075), .Y(n2061) );
  NAND2X1 U1625 ( .A(n1903), .B(n1529), .Y(n2060) );
  NAND2XL U1626 ( .A(n1017), .B(n1528), .Y(n1529) );
  NAND2X1 U1627 ( .A(n1964), .B(n1963), .Y(n1965) );
  NOR2XL U1628 ( .A(n1886), .B(n2113), .Y(n1878) );
  INVXL U1629 ( .A(n1635), .Y(n1034) );
  AOI22XL U1630 ( .A0(n1862), .A1(tetris_temp[38]), .B0(n1861), .B1(
        tetris_temp[44]), .Y(n1538) );
  INVXL U1631 ( .A(n2049), .Y(n2140) );
  NAND3XL U1632 ( .A(cnt[0]), .B(score_valid), .C(n2160), .Y(n2161) );
  AOI2BB1XL U1633 ( .A0N(cnt[0]), .A1N(tetris_valid), .B0(n2164), .Y(n2159) );
  OAI2BB1XL U1634 ( .A0N(n2010), .A1N(n1920), .B0(n1544), .Y(n2075) );
  NAND2XL U1635 ( .A(n1615), .B(n1017), .Y(n2074) );
  OAI2BB1XL U1636 ( .A0N(n2010), .A1N(n1747), .B0(n1614), .Y(n1615) );
  INVXL U1637 ( .A(n1901), .Y(n2055) );
  INVXL U1638 ( .A(n2113), .Y(n2076) );
  INVXL U1639 ( .A(n2098), .Y(n2090) );
  AND2X1 U1640 ( .A(score_valid), .B(score_temp[1]), .Y(score[1]) );
  AND2X1 U1641 ( .A(score_valid), .B(score_temp[2]), .Y(score[2]) );
  OAI211XL U1642 ( .A0(n1900), .A1(n1944), .B0(n1832), .C0(n1831), .Y(
        n_tetris_temp[32]) );
  OAI211XL U1643 ( .A0(n1900), .A1(n1874), .B0(n1873), .C0(n1872), .Y(
        n_tetris_temp[34]) );
  INVXL U1644 ( .A(n1909), .Y(n1464) );
  OAI22XL U1645 ( .A0(n2004), .A1(n2052), .B0(n2136), .B1(n1919), .Y(n1751) );
  OAI2BB1XL U1646 ( .A0N(n2007), .A1N(n1822), .B0(n1802), .Y(n_tetris_temp[14]) );
  OAI2BB1XL U1647 ( .A0N(n2040), .A1N(n1822), .B0(n1815), .Y(n_tetris_temp[13]) );
  OAI2BB1XL U1648 ( .A0N(n2129), .A1N(n1822), .B0(n1807), .Y(n_tetris_temp[16]) );
  OAI211XL U1649 ( .A0(n1811), .A1(n1874), .B0(n1804), .C0(n1803), .Y(n1805)
         );
  OAI2BB1XL U1650 ( .A0N(n2018), .A1N(n1822), .B0(n1791), .Y(n_tetris_temp[17]) );
  AOI211XL U1651 ( .A0(n1951), .A1(n1981), .B0(n1790), .C0(n1789), .Y(n1791)
         );
  OAI22XL U1652 ( .A0(n1786), .A1(n2024), .B0(n1915), .B1(n1892), .Y(n1677) );
  OAI2BB1XL U1653 ( .A0N(n2105), .A1N(n1822), .B0(n1821), .Y(n_tetris_temp[12]) );
  OAI31XL U1654 ( .A0(n1909), .A1(n1908), .A2(n2032), .B0(n1493), .Y(
        n_tetris_temp[61]) );
  OAI22XL U1655 ( .A0(n2068), .A1(n2046), .B0(n2034), .B1(n1901), .Y(n1492) );
  OAI2BB1XL U1656 ( .A0N(n2007), .A1N(n1956), .B0(n1955), .Y(n_tetris_temp[8])
         );
  OAI31XL U1657 ( .A0(n1909), .A1(n1908), .A2(n1991), .B0(n1479), .Y(
        n_tetris_temp[64]) );
  OAI21XL U1658 ( .A0(n2068), .A1(n2116), .B0(n1030), .Y(n1029) );
  OAI22XL U1659 ( .A0(n2068), .A1(n2052), .B0(n2136), .B1(n1901), .Y(n1755) );
  OAI211XL U1660 ( .A0(n1900), .A1(n2133), .B0(n1836), .C0(n1835), .Y(
        n_tetris_temp[33]) );
  OAI22XL U1661 ( .A0(n2117), .A1(n1915), .B0(n1901), .B1(n2024), .Y(n1574) );
  OAI22XL U1662 ( .A0(n2117), .A1(n2136), .B0(n1901), .B1(n2052), .Y(n1569) );
  OAI22XL U1663 ( .A0(n2107), .A1(n2151), .B0(n2108), .B1(n2145), .Y(n2101) );
  OAI2BB1XL U1664 ( .A0N(n2007), .A1N(n2128), .B0(n2003), .Y(n_tetris_temp[74]) );
  OAI22XL U1665 ( .A0(n2107), .A1(n2149), .B0(n2108), .B1(n2143), .Y(n2012) );
  OAI22XL U1666 ( .A0(n2107), .A1(n2148), .B0(n2108), .B1(n2142), .Y(n2042) );
  OAI2BB1XL U1667 ( .A0N(n2105), .A1N(n2128), .B0(n2099), .Y(n_tetris_temp[72]) );
  OAI2BB2XL U1668 ( .B0(n2137), .B1(n2034), .A0N(tetris_temp[1]), .A1N(n2132), 
        .Y(n1579) );
  NOR2X1 U1669 ( .A(score_temp[2]), .B(n1626), .Y(n1625) );
  AOI2BB1XL U1670 ( .A0N(score_valid), .A1N(cnt[0]), .B0(n2159), .Y(n_cnt[0])
         );
  OAI2BB1XL U1671 ( .A0N(n2018), .A1N(n2131), .B0(n1694), .Y(n_tetris_temp[5])
         );
  OAI22XL U1672 ( .A0(n2107), .A1(n2152), .B0(n2108), .B1(n2146), .Y(n2020) );
  OAI22XL U1673 ( .A0(n2107), .A1(n2150), .B0(n2108), .B1(n2144), .Y(n2048) );
  BUFX4 U1674 ( .A(n1828), .Y(n1897) );
  NOR2X2 U1675 ( .A(n1002), .B(n1612), .Y(n999) );
  BUFX4 U1676 ( .A(n1245), .Y(n1246) );
  INVXL U1677 ( .A(n1542), .Y(n2081) );
  NAND3X2 U1678 ( .A(n1457), .B(n1455), .C(tetrominoes[2]), .Y(n1440) );
  INVX2 U1679 ( .A(n1332), .Y(n1382) );
  INVX2 U1680 ( .A(n1305), .Y(n1502) );
  NAND2X2 U1681 ( .A(n1402), .B(n1299), .Y(n1360) );
  INVX4 U1682 ( .A(n1435), .Y(n1379) );
  NAND2X1 U1683 ( .A(n1470), .B(position[0]), .Y(n1248) );
  NAND2X4 U1684 ( .A(n1425), .B(n1357), .Y(n1543) );
  OAI2BB1X2 U1685 ( .A0N(n1811), .A1N(n1781), .B0(n2058), .Y(n1785) );
  INVX2 U1686 ( .A(n1211), .Y(n1212) );
  CLKINVX3 U1687 ( .A(n1792), .Y(n1886) );
  INVX2 U1688 ( .A(n1361), .Y(n1362) );
  NAND3X2 U1689 ( .A(n1360), .B(n1008), .C(n1358), .Y(n1422) );
  OAI2BB1X4 U1690 ( .A0N(n1431), .A1N(n1962), .B0(n1068), .Y(n1002) );
  OAI21X1 U1691 ( .A0(n1792), .A1(n1808), .B0(n1782), .Y(n1583) );
  NOR2XL U1692 ( .A(n1037), .B(n1962), .Y(n1608) );
  AOI2BB2X2 U1693 ( .B0(n1828), .B1(n1782), .A0N(n1598), .A1N(n1597), .Y(n1032) );
  NAND2X1 U1694 ( .A(n1211), .B(n1203), .Y(n1272) );
  AND2X4 U1695 ( .A(n1148), .B(n1316), .Y(n1003) );
  AND2X2 U1696 ( .A(n1136), .B(n1137), .Y(n1004) );
  OR2XL U1697 ( .A(n1302), .B(n1301), .Y(n1059) );
  NAND2X1 U1698 ( .A(n1499), .B(n1336), .Y(n1175) );
  NOR3X2 U1699 ( .A(n1271), .B(n1270), .C(n1269), .Y(n1300) );
  AOI22X1 U1700 ( .A0(n992), .A1(n1336), .B0(position[2]), .B1(n1337), .Y(
        n1224) );
  AOI22X1 U1701 ( .A0(n992), .A1(n1338), .B0(position[2]), .B1(n1335), .Y(
        n1234) );
  OAI2BB1X2 U1702 ( .A0N(n1300), .A1N(n1355), .B0(n1405), .Y(n1359) );
  NOR2XL U1703 ( .A(n1435), .B(n1436), .Y(n2018) );
  NAND2X4 U1704 ( .A(n1055), .B(n1369), .Y(n1005) );
  NAND3X1 U1705 ( .A(n1342), .B(n1013), .C(n1339), .Y(n1006) );
  NAND3X2 U1706 ( .A(n1342), .B(n1013), .C(n1339), .Y(n1373) );
  OAI211X4 U1707 ( .A0(n1811), .A1(n2133), .B0(n1794), .C0(n1793), .Y(n1795)
         );
  OAI211X4 U1708 ( .A0(n1811), .A1(n1944), .B0(n1799), .C0(n1798), .Y(n1800)
         );
  NAND3X1 U1709 ( .A(n1246), .B(n1021), .C(n1308), .Y(n1043) );
  MXI2X4 U1710 ( .A(n1386), .B(n1383), .S0(position[1]), .Y(n1191) );
  INVX8 U1711 ( .A(position[1]), .Y(n1016) );
  NAND2X2 U1712 ( .A(n1808), .B(n1595), .Y(n2141) );
  INVXL U1713 ( .A(n1595), .Y(n1599) );
  NAND3X2 U1714 ( .A(n1597), .B(n1596), .C(n1595), .Y(n1823) );
  OAI211X1 U1715 ( .A0(n1309), .A1(n1435), .B0(n1044), .C0(n1043), .Y(n1310)
         );
  NAND2X1 U1716 ( .A(n1379), .B(n1336), .Y(n1341) );
  XOR2X4 U1717 ( .A(n1284), .B(n1283), .Y(n1405) );
  NAND2X1 U1718 ( .A(n1417), .B(n1416), .Y(n1418) );
  NAND2X1 U1719 ( .A(n2068), .B(n1611), .Y(n1716) );
  OAI211X1 U1720 ( .A0(n1313), .A1(n1435), .B0(n1311), .C0(n1312), .Y(n1314)
         );
  INVXL U1721 ( .A(n1366), .Y(n1009) );
  INVX2 U1722 ( .A(n1009), .Y(n1010) );
  NAND2X1 U1723 ( .A(n1354), .B(n1328), .Y(n1366) );
  NAND2X2 U1724 ( .A(n1330), .B(n1014), .Y(n1402) );
  NAND4X2 U1725 ( .A(n1062), .B(n1061), .C(n1060), .D(n1059), .Y(n1306) );
  NAND3X2 U1726 ( .A(n1771), .B(n1069), .C(n1039), .Y(n1011) );
  NAND3X2 U1727 ( .A(n1771), .B(n1069), .C(n1039), .Y(n1054) );
  INVX2 U1728 ( .A(n1377), .Y(n1026) );
  NAND2X1 U1729 ( .A(n1382), .B(n1316), .Y(n1323) );
  NAND2X1 U1730 ( .A(n1340), .B(n1341), .Y(n1012) );
  INVX2 U1731 ( .A(n1012), .Y(n1013) );
  OAI211X1 U1732 ( .A0(n1333), .A1(n1332), .B0(n1056), .C0(n1057), .Y(n1334)
         );
  OR2X2 U1733 ( .A(n1332), .B(n1309), .Y(n1060) );
  AOI2BB2X4 U1734 ( .B0(n1421), .B1(n1426), .A0N(n1393), .A1N(n1058), .Y(n1647) );
  NAND2X2 U1735 ( .A(n1315), .B(n1328), .Y(n1369) );
  INVX2 U1736 ( .A(n1356), .Y(n1329) );
  OAI21X2 U1737 ( .A0(n1284), .A1(n1283), .B0(n1300), .Y(n1014) );
  AOI2BB1X2 U1738 ( .A0N(n1597), .A1N(n1647), .B0(n1897), .Y(n1900) );
  OAI21X1 U1739 ( .A0(n1284), .A1(n1283), .B0(n1300), .Y(n1356) );
  INVX4 U1740 ( .A(position[1]), .Y(n1220) );
  INVX4 U1741 ( .A(position[1]), .Y(n1042) );
  BUFX8 U1742 ( .A(n1063), .Y(n1037) );
  INVX8 U1743 ( .A(position[0]), .Y(n1015) );
  NAND3X2 U1744 ( .A(n1223), .B(n1446), .C(n1222), .Y(n1025) );
  NAND3X4 U1745 ( .A(n1022), .B(n1007), .C(n1023), .Y(n1068) );
  NAND2BX4 U1746 ( .AN(n1424), .B(n1027), .Y(n1022) );
  INVX2 U1747 ( .A(n1063), .Y(n1961) );
  NAND2X4 U1748 ( .A(n1543), .B(n1364), .Y(n1063) );
  NOR2X4 U1749 ( .A(n1365), .B(n1010), .Y(n1393) );
  INVX2 U1750 ( .A(n1430), .Y(n1023) );
  AOI211X1 U1751 ( .A0(n1897), .A1(n2090), .B0(n1767), .C0(n1766), .Y(n1773)
         );
  NOR2X4 U1752 ( .A(n1262), .B(n1261), .Y(n1283) );
  NAND2X4 U1753 ( .A(n1025), .B(n1024), .Y(n1395) );
  AOI2BB2X4 U1754 ( .B0(n1253), .B1(n1383), .A0N(n1268), .A1N(n1347), .Y(n1024) );
  OAI21X2 U1755 ( .A0(n1425), .A1(n1423), .B0(n1394), .Y(n1431) );
  NOR3X4 U1756 ( .A(n1026), .B(n1432), .C(n1393), .Y(n1394) );
  INVX4 U1757 ( .A(n1425), .Y(n1027) );
  NAND2XL U1758 ( .A(n2006), .B(n1928), .Y(n1884) );
  INVX2 U1759 ( .A(n1291), .Y(n1277) );
  NAND2X4 U1760 ( .A(n1297), .B(n1298), .Y(n1425) );
  OAI2BB1XL U1761 ( .A0N(n2007), .A1N(n1774), .B0(n1674), .Y(n_tetris_temp[26]) );
  OAI2BB1XL U1762 ( .A0N(n2018), .A1N(n1774), .B0(n1678), .Y(n_tetris_temp[29]) );
  NOR2X1 U1763 ( .A(n1445), .B(n1444), .Y(n2024) );
  NAND2XL U1764 ( .A(n1169), .B(n1225), .Y(n1170) );
  BUFX8 U1765 ( .A(n1331), .Y(n1421) );
  NAND3X4 U1766 ( .A(n1395), .B(n1737), .C(n1403), .Y(n1284) );
  CLKINVX3 U1767 ( .A(n1028), .Y(n1124) );
  NOR2X4 U1768 ( .A(n1449), .B(position[0]), .Y(n1499) );
  AOI211X1 U1769 ( .A0(n2094), .A1(n990), .B0(n1778), .C0(n1777), .Y(n1779) );
  INVX2 U1770 ( .A(n1393), .Y(n1428) );
  OAI211X1 U1771 ( .A0(n1886), .A1(n2052), .B0(n1592), .C0(n1593), .Y(n1594)
         );
  NOR2X1 U1772 ( .A(n1478), .B(n1029), .Y(n1479) );
  AOI2BB2XL U1773 ( .B0(n2064), .B1(n2122), .A0N(n1901), .A1N(n2115), .Y(n1030) );
  NAND2X4 U1774 ( .A(n1045), .B(n1049), .Y(n1055) );
  NOR2X2 U1775 ( .A(n1355), .B(n1014), .Y(n1365) );
  NAND2X2 U1776 ( .A(n1324), .B(n1533), .Y(n1343) );
  BUFX4 U1777 ( .A(n1169), .Y(n1237) );
  AOI211X1 U1778 ( .A0(n1814), .A1(n2047), .B0(n1796), .C0(n1795), .Y(n1797)
         );
  AOI211X1 U1779 ( .A0(n1814), .A1(n2006), .B0(n1801), .C0(n1800), .Y(n1802)
         );
  NAND2X1 U1780 ( .A(n2040), .B(n1881), .Y(n1606) );
  AOI211X1 U1781 ( .A0(n1814), .A1(n2039), .B0(n1813), .C0(n1812), .Y(n1815)
         );
  NOR2X4 U1782 ( .A(n1003), .B(n1031), .Y(n1136) );
  NAND2X2 U1783 ( .A(n1292), .B(n1290), .Y(n1208) );
  INVX8 U1784 ( .A(n1591), .Y(n1036) );
  MXI2X2 U1785 ( .A(n1294), .B(n1293), .S0(n1004), .Y(n1299) );
  AOI211X1 U1786 ( .A0(n1814), .A1(n2100), .B0(n1806), .C0(n1805), .Y(n1807)
         );
  OAI21X4 U1787 ( .A0(n1033), .A1(n2092), .B0(n1032), .Y(n1881) );
  AOI2BB2X2 U1788 ( .B0(n1282), .B1(n1281), .A0N(n1412), .A1N(n1406), .Y(n1298) );
  AOI211X1 U1789 ( .A0(n2064), .A1(n2021), .B0(n1461), .C0(n1460), .Y(n1462)
         );
  AOI211X1 U1790 ( .A0(n2049), .A1(n2073), .B0(n1570), .C0(n1569), .Y(n1571)
         );
  AOI21X1 U1791 ( .A0(n1429), .A1(n1428), .B0(n1427), .Y(n1430) );
  INVX4 U1792 ( .A(n1725), .Y(n1928) );
  NAND2X4 U1793 ( .A(n1035), .B(n1036), .Y(n1725) );
  INVX4 U1794 ( .A(n1811), .Y(n1035) );
  OAI21X4 U1795 ( .A0(n999), .A1(n1828), .B0(n2058), .Y(n1771) );
  NOR2X4 U1796 ( .A(n1500), .B(n1577), .Y(n1828) );
  MXI2X2 U1797 ( .A(n1296), .B(n1295), .S0(n1413), .Y(n1297) );
  NAND2X2 U1798 ( .A(n1439), .B(n1648), .Y(n2004) );
  AOI211X1 U1799 ( .A0(n990), .A1(n2049), .B0(n1751), .C0(n1750), .Y(n1752) );
  OAI211X1 U1800 ( .A0(n1886), .A1(n2016), .B0(n1884), .C0(n1885), .Y(n1887)
         );
  AOI211X1 U1801 ( .A0(n2019), .A1(n2125), .B0(n1658), .C0(n1657), .Y(n1659)
         );
  OAI211X1 U1802 ( .A0(n1919), .A1(n2024), .B0(n1838), .C0(n1837), .Y(n1840)
         );
  OAI22XL U1803 ( .A0(n1786), .A1(n2116), .B0(n2115), .B1(n1892), .Y(n1687) );
  NAND2X4 U1804 ( .A(n1770), .B(n1040), .Y(n1039) );
  INVX2 U1805 ( .A(n1469), .Y(n1041) );
  NAND2X4 U1806 ( .A(n1015), .B(n1042), .Y(n1469) );
  NAND2X4 U1807 ( .A(n1042), .B(position[0]), .Y(n1435) );
  NOR2X2 U1808 ( .A(n1435), .B(position[2]), .Y(n1501) );
  NAND3X2 U1809 ( .A(n1048), .B(n1046), .C(n1047), .Y(n1045) );
  NAND2X2 U1810 ( .A(n1346), .B(n1345), .Y(n1046) );
  OAI21X2 U1811 ( .A0(n1353), .A1(n1006), .B0(n1352), .Y(n1047) );
  AOI2BB2X4 U1812 ( .B0(n1051), .B1(n1050), .A0N(n1053), .A1N(n1328), .Y(n1049) );
  INVX2 U1813 ( .A(n1345), .Y(n1050) );
  CLKINVX2 U1814 ( .A(n1354), .Y(n1053) );
  NAND2X4 U1815 ( .A(n1306), .B(n1533), .Y(n1354) );
  NAND2XL U1816 ( .A(n1011), .B(n2105), .Y(n1772) );
  AOI22XL U1817 ( .A0(n1011), .A1(n2040), .B0(n1891), .B1(n2043), .Y(n1827) );
  AOI22XL U1818 ( .A0(n1011), .A1(n2130), .B0(n1891), .B1(n2049), .Y(n1836) );
  AOI22XL U1819 ( .A0(n1054), .A1(n2018), .B0(n1891), .B1(n2021), .Y(n1899) );
  AOI22XL U1820 ( .A0(n1054), .A1(n2007), .B0(n1891), .B1(n2013), .Y(n1832) );
  AOI22XL U1821 ( .A0(n1054), .A1(n2129), .B0(n1891), .B1(n2122), .Y(n1873) );
  NAND2X1 U1822 ( .A(n1426), .B(n1058), .Y(n1429) );
  OR2X4 U1823 ( .A(n1327), .B(n1326), .Y(n1358) );
  OAI2BB1X2 U1824 ( .A0N(n1662), .A1N(n1828), .B0(n1661), .Y(n1774) );
  OAI22XL U1825 ( .A0(n2004), .A1(n2016), .B0(n1999), .B1(n1919), .Y(n1844) );
  AOI211X1 U1826 ( .A0(n2013), .A1(n1816), .B0(n1673), .C0(n1672), .Y(n1674)
         );
  NAND2XL U1827 ( .A(n2047), .B(n1928), .Y(n1592) );
  INVX4 U1828 ( .A(n1928), .Y(n1786) );
  AOI211X1 U1829 ( .A0(n2064), .A1(n2013), .B0(n1906), .C0(n1905), .Y(n1907)
         );
  NAND2X2 U1830 ( .A(n1063), .B(n1958), .Y(n1612) );
  NAND2X4 U1831 ( .A(n1360), .B(n1359), .Y(n1426) );
  OAI22XL U1832 ( .A0(n1786), .A1(n2046), .B0(n2034), .B1(n1892), .Y(n1665) );
  INVX3 U1833 ( .A(n1063), .Y(n1064) );
  NAND2X4 U1834 ( .A(n1064), .B(n1958), .Y(n2026) );
  OAI211X1 U1835 ( .A0(n1927), .A1(n1984), .B0(n1067), .C0(n1065), .Y(
        n_tetris_temp[41]) );
  NOR2XL U1836 ( .A(n1919), .B(n1915), .Y(n1066) );
  NAND2X4 U1837 ( .A(n1910), .B(n1577), .Y(n1919) );
  AOI2BB2X1 U1838 ( .B0(n2021), .B1(n990), .A0N(n2004), .A1N(n2024), .Y(n1067)
         );
  INVX8 U1839 ( .A(n1613), .Y(n1591) );
  OAI2BB1X4 U1840 ( .A0N(n1431), .A1N(n1962), .B0(n1068), .Y(n1613) );
  AOI211X1 U1841 ( .A0(n1867), .A1(n2013), .B0(n1540), .C0(n1539), .Y(n1541)
         );
  NAND2X2 U1842 ( .A(n1314), .B(n1450), .Y(n1345) );
  NOR2X2 U1843 ( .A(n1063), .B(n1960), .Y(n1609) );
  INVX4 U1844 ( .A(n1957), .Y(n2064) );
  BUFX1 U1845 ( .A(n1379), .Y(n1380) );
  INVXL U1846 ( .A(rst_n), .Y(n1621) );
  BUFX1 U1847 ( .A(n1503), .Y(n1504) );
  NOR2XL U1848 ( .A(tetris_temp[66]), .B(tetris_temp[72]), .Y(n1227) );
  INVXL U1849 ( .A(n1230), .Y(n1229) );
  INVXL U1850 ( .A(n1301), .Y(n1308) );
  INVXL U1851 ( .A(n1347), .Y(n1384) );
  XOR2XL U1852 ( .A(n1396), .B(n1737), .Y(n1420) );
  INVXL U1853 ( .A(n2039), .Y(n2034) );
  INVXL U1854 ( .A(n2116), .Y(n1988) );
  BUFX1 U1855 ( .A(n1437), .Y(n1468) );
  NOR2X2 U1856 ( .A(n2160), .B(n2166), .Y(tetris[0]) );
  NAND4XL U1857 ( .A(tetris_temp[64]), .B(tetris_temp[62]), .C(tetris_temp[61]), .D(tetris_temp[60]), .Y(n1072) );
  NAND2XL U1858 ( .A(tetris_temp[65]), .B(tetris_temp[63]), .Y(n1071) );
  NAND4X1 U1859 ( .A(tetris_temp[71]), .B(tetris_temp[69]), .C(tetris_temp[68]), .D(tetris_temp[67]), .Y(n1074) );
  NAND2XL U1860 ( .A(tetris_temp[70]), .B(tetris_temp[66]), .Y(n1073) );
  NOR2X1 U1861 ( .A(n1074), .B(n1073), .Y(n1520) );
  NAND2XL U1862 ( .A(tetris_temp[76]), .B(tetris_temp[72]), .Y(n1075) );
  NAND4XL U1863 ( .A(tetris_temp[79]), .B(tetris_temp[80]), .C(tetris_temp[83]), .D(tetris_temp[82]), .Y(n1078) );
  NAND2XL U1864 ( .A(tetris_temp[81]), .B(tetris_temp[78]), .Y(n1077) );
  NAND2XL U1865 ( .A(tetris_temp[53]), .B(tetris_temp[52]), .Y(n1081) );
  NAND2XL U1866 ( .A(tetris_temp[50]), .B(tetris_temp[49]), .Y(n1079) );
  NOR2X2 U1867 ( .A(n2009), .B(n1084), .Y(n1508) );
  NOR2X2 U1868 ( .A(n1747), .B(n1637), .Y(n1622) );
  AND2X4 U1869 ( .A(n1622), .B(n1100), .Y(score_valid) );
  NAND4X1 U1870 ( .A(cnt[1]), .B(cnt[2]), .C(cnt[0]), .D(cnt[3]), .Y(n1105) );
  NAND2X1 U1871 ( .A(n1632), .B(n1105), .Y(n1106) );
  NAND2X4 U1872 ( .A(score_valid), .B(n1106), .Y(n1107) );
  NAND2X4 U1873 ( .A(n1470), .B(position[1]), .Y(n1449) );
  NOR2X4 U1874 ( .A(n1449), .B(n1015), .Y(n1148) );
  AOI2BB2X2 U1875 ( .B0(n1501), .B1(n1184), .A0N(n1503), .A1N(n1303), .Y(n1115) );
  INVX8 U1876 ( .A(position[0]), .Y(n1245) );
  NAND2X4 U1877 ( .A(n1245), .B(position[2]), .Y(n1267) );
  NOR2X4 U1878 ( .A(n1267), .B(n1020), .Y(n1437) );
  NOR2X4 U1879 ( .A(position[2]), .B(position[0]), .Y(n1203) );
  NAND2X2 U1880 ( .A(n1220), .B(n1203), .Y(n1739) );
  INVXL U1881 ( .A(n1263), .Y(n1164) );
  OAI211X2 U1882 ( .A0(n1309), .A1(n1116), .B0(n1115), .C0(n1114), .Y(n1210)
         );
  NOR2X4 U1883 ( .A(tetrominoes[2]), .B(n1931), .Y(n2058) );
  INVX2 U1884 ( .A(n2058), .Y(n1209) );
  INVXL U1885 ( .A(n1139), .Y(n1118) );
  INVXL U1886 ( .A(n1138), .Y(n1117) );
  NAND2X2 U1887 ( .A(n1437), .B(n1318), .Y(n1122) );
  NOR2X4 U1888 ( .A(n1124), .B(n1123), .Y(n1137) );
  INVXL U1889 ( .A(n1145), .Y(n1126) );
  INVXL U1890 ( .A(n1143), .Y(n1125) );
  INVXL U1891 ( .A(n1163), .Y(n1129) );
  INVXL U1892 ( .A(n1166), .Y(n1128) );
  NOR2X4 U1893 ( .A(position[2]), .B(position[1]), .Y(n1235) );
  BUFX4 U1894 ( .A(n1235), .Y(n1480) );
  INVXL U1895 ( .A(n1158), .Y(n1132) );
  INVXL U1896 ( .A(n1160), .Y(n1131) );
  NAND2X4 U1897 ( .A(n1136), .B(n1137), .Y(n1292) );
  OAI21XL U1898 ( .A0(tetris_temp[69]), .A1(tetris_temp[75]), .B0(n1138), .Y(
        n1142) );
  OAI21XL U1899 ( .A0(tetris_temp[70]), .A1(tetris_temp[76]), .B0(n1143), .Y(
        n1144) );
  INVXL U1900 ( .A(n1179), .Y(n1151) );
  NAND2XL U1901 ( .A(n1151), .B(n1150), .Y(n1157) );
  INVXL U1902 ( .A(n1152), .Y(n1153) );
  OAI21XL U1903 ( .A0(tetris_temp[68]), .A1(tetris_temp[74]), .B0(n1158), .Y(
        n1159) );
  OAI2BB1XL U1904 ( .A0N(n1160), .A1N(n1159), .B0(n1304), .Y(n1161) );
  OAI21XL U1905 ( .A0(tetris_temp[67]), .A1(tetris_temp[73]), .B0(n1163), .Y(
        n1165) );
  OAI2BB1XL U1906 ( .A0N(n1166), .A1N(n1165), .B0(n1164), .Y(n1167) );
  OAI2BB1X1 U1907 ( .A0N(n1171), .A1N(n1170), .B0(n1235), .Y(n1172) );
  NAND4X2 U1908 ( .A(n1175), .B(n1174), .C(n1173), .D(n1172), .Y(n1290) );
  INVXL U1909 ( .A(tetris_temp[83]), .Y(n2146) );
  AOI2BB1XL U1910 ( .A0N(n2201), .A1N(tetris_temp[29]), .B0(tetris_temp[23]), 
        .Y(n1177) );
  NOR2X2 U1911 ( .A(n1470), .B(position[1]), .Y(n1442) );
  INVXL U1912 ( .A(tetris_temp[80]), .Y(n2143) );
  OAI21XL U1913 ( .A0(tetris_temp[74]), .A1(n2143), .B0(n2168), .Y(n1181) );
  AOI21XL U1914 ( .A0(n1181), .A1(n2172), .B0(tetris_temp[56]), .Y(n1182) );
  AOI2BB1XL U1915 ( .A0N(n1182), .A1N(tetris_temp[50]), .B0(tetris_temp[44]), 
        .Y(n1185) );
  INVXL U1916 ( .A(tetris_temp[82]), .Y(n2145) );
  OAI21XL U1917 ( .A0(tetris_temp[76]), .A1(n2145), .B0(n2169), .Y(n1186) );
  AOI21XL U1918 ( .A0(n1186), .A1(n2174), .B0(tetris_temp[58]), .Y(n1187) );
  NAND2X4 U1919 ( .A(tetrominoes[1]), .B(tetrominoes[2]), .Y(n1204) );
  INVXL U1920 ( .A(tetris_temp[79]), .Y(n2142) );
  OAI21XL U1921 ( .A0(tetris_temp[73]), .A1(n2142), .B0(n2167), .Y(n1193) );
  AOI21XL U1922 ( .A0(n1193), .A1(n2171), .B0(tetris_temp[55]), .Y(n1194) );
  AOI2BB1XL U1923 ( .A0N(n1194), .A1N(tetris_temp[49]), .B0(tetris_temp[43]), 
        .Y(n1196) );
  AOI2BB1XL U1924 ( .A0N(n2197), .A1N(tetris_temp[25]), .B0(tetris_temp[19]), 
        .Y(n1195) );
  OAI22XL U1925 ( .A0(n1196), .A1(n1263), .B0(tetris_temp[13]), .B1(n1195), 
        .Y(n1197) );
  INVXL U1926 ( .A(tetris_temp[81]), .Y(n2144) );
  INVXL U1927 ( .A(tetris_temp[69]), .Y(n2153) );
  OAI21XL U1928 ( .A0(tetris_temp[75]), .A1(n2144), .B0(n2153), .Y(n1198) );
  AOI21XL U1929 ( .A0(n1198), .A1(n2173), .B0(tetris_temp[57]), .Y(n1199) );
  OAI21XL U1930 ( .A0(n1199), .A1(tetris_temp[51]), .B0(n2189), .Y(n1201) );
  AOI2BB1XL U1931 ( .A0N(n2199), .A1N(tetris_temp[27]), .B0(tetris_temp[21]), 
        .Y(n1200) );
  BUFX2 U1932 ( .A(n1204), .Y(n1466) );
  INVX1 U1933 ( .A(n1485), .Y(n1205) );
  AOI21X2 U1934 ( .A0(n1207), .A1(n1241), .B0(n1206), .Y(n1275) );
  AOI2BB2X4 U1935 ( .B0(n1210), .B1(n1209), .A0N(n1208), .A1N(n1275), .Y(n1330) );
  NAND2X2 U1936 ( .A(n991), .B(n1212), .Y(n1223) );
  INVXL U1937 ( .A(tetris_temp[30]), .Y(n2158) );
  OAI21XL U1938 ( .A0(n2186), .A1(tetris_temp[36]), .B0(n2158), .Y(n1213) );
  AOI21XL U1939 ( .A0(n1213), .A1(n2202), .B0(tetris_temp[18]), .Y(n1218) );
  NOR4XL U1940 ( .A(tetris_temp[12]), .B(tetris_temp[36]), .C(tetris_temp[24]), 
        .D(tetris_temp[48]), .Y(n1215) );
  OAI21XL U1941 ( .A0(n1216), .A1(tetris_temp[54]), .B0(n1215), .Y(n1217) );
  OAI22X4 U1942 ( .A0(n1220), .A1(n1386), .B0(n1219), .B1(n992), .Y(n1221) );
  INVXL U1943 ( .A(tetris_temp[54]), .Y(n2155) );
  INVXL U1944 ( .A(tetris_temp[60]), .Y(n2154) );
  NAND2XL U1945 ( .A(n2155), .B(n2154), .Y(n1242) );
  AOI2BB1XL U1946 ( .A0N(n1242), .A1N(n1227), .B0(tetris_temp[48]), .Y(n1233)
         );
  NAND2XL U1947 ( .A(n2202), .B(n2208), .Y(n1230) );
  INVXL U1948 ( .A(tetris_temp[36]), .Y(n2157) );
  AOI21XL U1949 ( .A0(n1231), .A1(tetris_temp[42]), .B0(n1230), .Y(n1232) );
  OAI22XL U1950 ( .A0(n1233), .A1(n1265), .B0(n1232), .B1(tetris_temp[12]), 
        .Y(n1236) );
  OAI2BB1X2 U1951 ( .A0N(n1236), .A1N(n1235), .B0(n1234), .Y(n1238) );
  CLKINVX8 U1952 ( .A(tetrominoes[0]), .Y(n1455) );
  BUFX8 U1953 ( .A(n1305), .Y(n1737) );
  INVXL U1954 ( .A(n1242), .Y(n1244) );
  NAND4X2 U1955 ( .A(n1257), .B(n1256), .C(n1255), .D(n1254), .Y(n1262) );
  NAND2X1 U1956 ( .A(n1272), .B(n1273), .Y(n1399) );
  OAI21X1 U1957 ( .A0(n1399), .A1(n1466), .B0(n1397), .Y(n1289) );
  INVX1 U1958 ( .A(n1289), .Y(n1278) );
  INVX2 U1959 ( .A(n1275), .Y(n1291) );
  INVX1 U1960 ( .A(n1290), .Y(n1276) );
  MXI2X2 U1961 ( .A(n1278), .B(n1277), .S0(n1276), .Y(n1406) );
  NAND2XL U1962 ( .A(n1402), .B(n1406), .Y(n1282) );
  NAND2XL U1963 ( .A(n1737), .B(n1395), .Y(n1280) );
  XOR2X2 U1964 ( .A(n1280), .B(n1279), .Y(n1408) );
  INVX1 U1965 ( .A(n1408), .Y(n1281) );
  INVX4 U1966 ( .A(n1330), .Y(n1355) );
  NAND2X2 U1967 ( .A(n1355), .B(n1329), .Y(n1412) );
  INVX2 U1968 ( .A(n1405), .Y(n1285) );
  NAND2X1 U1969 ( .A(n1285), .B(n1402), .Y(n1286) );
  NAND2X2 U1970 ( .A(n1412), .B(n1405), .Y(n1414) );
  NOR2X2 U1971 ( .A(n1414), .B(n1408), .Y(n1295) );
  INVX2 U1972 ( .A(n1299), .Y(n1413) );
  NAND2X4 U1973 ( .A(n1502), .B(n1556), .Y(n1533) );
  NAND2X2 U1974 ( .A(n1310), .B(n1450), .Y(n1328) );
  INVXL U1975 ( .A(n1316), .Y(n1313) );
  NAND2XL U1976 ( .A(n1382), .B(n1318), .Y(n1312) );
  NAND2XL U1977 ( .A(n1557), .B(n1317), .Y(n1311) );
  AOI21X1 U1978 ( .A0(n1315), .A1(n1328), .B0(n1345), .Y(n1327) );
  NAND2XL U1979 ( .A(n1385), .B(n1318), .Y(n1321) );
  INVXL U1980 ( .A(n1324), .Y(n1325) );
  OAI22X1 U1981 ( .A0(n1325), .A1(n1354), .B0(n1344), .B1(n1343), .Y(n1326) );
  NAND3X1 U1982 ( .A(n1366), .B(n1329), .C(n1330), .Y(n1331) );
  INVXL U1983 ( .A(n1337), .Y(n1333) );
  NAND2X1 U1984 ( .A(n1385), .B(n1337), .Y(n1340) );
  INVX2 U1985 ( .A(n1343), .Y(n1346) );
  NAND2XL U1986 ( .A(n1382), .B(n1384), .Y(n1351) );
  NAND2XL U1987 ( .A(n1379), .B(n1383), .Y(n1350) );
  INVXL U1988 ( .A(n1348), .Y(n1381) );
  NAND2XL U1989 ( .A(n1557), .B(n1381), .Y(n1349) );
  NAND3XL U1990 ( .A(n1351), .B(n1350), .C(n1349), .Y(n1378) );
  NAND3X2 U1991 ( .A(n1361), .B(n995), .C(n1428), .Y(n1357) );
  INVX2 U1992 ( .A(n1421), .Y(n1427) );
  OAI21X2 U1993 ( .A0(n1363), .A1(n1427), .B0(n1362), .Y(n1364) );
  NOR2X2 U1994 ( .A(n1367), .B(n1010), .Y(n1649) );
  NAND2X2 U1995 ( .A(n1649), .B(n1647), .Y(n1960) );
  INVXL U1996 ( .A(n1368), .Y(n1372) );
  INVX1 U1997 ( .A(n1369), .Y(n1374) );
  NAND2X1 U1998 ( .A(n1374), .B(n1006), .Y(n1375) );
  NAND4X2 U1999 ( .A(n1422), .B(n1376), .C(n1421), .D(n1375), .Y(n1423) );
  NAND2XL U2000 ( .A(n1380), .B(n1381), .Y(n1390) );
  NAND2XL U2001 ( .A(n1382), .B(n1383), .Y(n1389) );
  NAND2XL U2002 ( .A(n1385), .B(n1384), .Y(n1388) );
  NAND2XL U2003 ( .A(n1557), .B(n1386), .Y(n1387) );
  MXI2X4 U2004 ( .A(n1392), .B(n1391), .S0(n1005), .Y(n1432) );
  BUFX1 U2005 ( .A(n1395), .Y(n1396) );
  INVXL U2006 ( .A(n1397), .Y(n1398) );
  INVXL U2007 ( .A(n1406), .Y(n1407) );
  NAND2X1 U2008 ( .A(n1408), .B(n1407), .Y(n1409) );
  MXI2X2 U2009 ( .A(n1420), .B(n1419), .S0(n1418), .Y(n1962) );
  NAND2XL U2010 ( .A(n1422), .B(n1421), .Y(n1424) );
  NAND2X4 U2011 ( .A(n2121), .B(n1036), .Y(n2117) );
  NAND2XL U2012 ( .A(n1432), .B(n1962), .Y(n1610) );
  AND2X2 U2013 ( .A(n1610), .B(n1063), .Y(n1653) );
  NOR2X4 U2014 ( .A(n2102), .B(n1434), .Y(n1909) );
  NOR2X4 U2015 ( .A(n2005), .B(n1647), .Y(n1958) );
  INVXL U2016 ( .A(n1553), .Y(n1465) );
  INVX4 U2017 ( .A(n1591), .Y(n1439) );
  INVX1 U2018 ( .A(n1612), .Y(n1438) );
  NAND2X4 U2019 ( .A(n1036), .B(n1438), .Y(n2068) );
  NAND2XL U2020 ( .A(n1564), .B(n1442), .Y(n1443) );
  INVXL U2021 ( .A(n1580), .Y(n1566) );
  OAI21X1 U2022 ( .A0(n2053), .A1(n1017), .B0(n1553), .Y(n1555) );
  NAND2XL U2023 ( .A(n2130), .B(n1737), .Y(n1452) );
  NAND3XL U2024 ( .A(n1450), .B(n1563), .C(n1018), .Y(n1451) );
  NOR2X1 U2025 ( .A(n1454), .B(n1453), .Y(n1915) );
  INVX2 U2026 ( .A(n1915), .Y(n2017) );
  NAND2X4 U2027 ( .A(n1591), .B(n1609), .Y(n1901) );
  INVXL U2028 ( .A(n1614), .Y(n1458) );
  INVXL U2029 ( .A(n1544), .Y(n1902) );
  AOI22XL U2030 ( .A0(tetris_temp[65]), .A1(n1903), .B0(n1902), .B1(
        tetris_temp[59]), .Y(n1459) );
  OAI2BB1X1 U2031 ( .A0N(n2019), .A1N(n2121), .B0(n1459), .Y(n1460) );
  OAI2BB1X2 U2032 ( .A0N(n1464), .A1N(n1463), .B0(n1462), .Y(n_tetris_temp[65]) );
  INVXL U2033 ( .A(n1476), .Y(n1475) );
  NAND2XL U2034 ( .A(n1471), .B(n1470), .Y(n1472) );
  AOI22XL U2035 ( .A0(tetris_temp[64]), .A1(n1903), .B0(n1902), .B1(
        tetris_temp[58]), .Y(n1477) );
  OAI2BB1X1 U2036 ( .A0N(n2126), .A1N(n2121), .B0(n1477), .Y(n1478) );
  NOR2XL U2037 ( .A(n1553), .B(n1739), .Y(n2043) );
  BUFX1 U2038 ( .A(n1480), .Y(n1481) );
  NAND2XL U2039 ( .A(n1564), .B(n1481), .Y(n1482) );
  AOI22XL U2040 ( .A0(tetris_temp[61]), .A1(n1903), .B0(n1902), .B1(
        tetris_temp[55]), .Y(n1490) );
  OAI2BB1X1 U2041 ( .A0N(n2041), .A1N(n2121), .B0(n1490), .Y(n1491) );
  AOI211X1 U2042 ( .A0(n2064), .A1(n2043), .B0(n1492), .C0(n1491), .Y(n1493)
         );
  NAND2X2 U2043 ( .A(n1002), .B(n1037), .Y(n1595) );
  NAND2X4 U2044 ( .A(n1591), .B(n1961), .Y(n1597) );
  NAND3X4 U2045 ( .A(n1597), .B(n1958), .C(n1595), .Y(n1860) );
  OAI211X1 U2046 ( .A0(n1497), .A1(n1496), .B0(n1860), .C0(n1495), .Y(n1498)
         );
  INVX4 U2047 ( .A(n1002), .Y(n1577) );
  AND2X4 U2048 ( .A(n1647), .B(n2005), .Y(n1596) );
  NAND2X4 U2049 ( .A(n1063), .B(n1596), .Y(n1500) );
  NAND2X2 U2050 ( .A(n1781), .B(n1919), .Y(n1867) );
  NAND2XL U2051 ( .A(n1505), .B(n1502), .Y(n1507) );
  INVXL U2052 ( .A(n1508), .Y(n1516) );
  INVXL U2053 ( .A(n1509), .Y(n1511) );
  NOR3XL U2054 ( .A(n1512), .B(n1511), .C(n1510), .Y(n1515) );
  INVXL U2055 ( .A(n1513), .Y(n1545) );
  INVXL U2056 ( .A(n1519), .Y(n1521) );
  OAI2BB1X1 U2057 ( .A0N(n1614), .A1N(n1530), .B0(n2061), .Y(n1862) );
  NOR2X4 U2058 ( .A(n2026), .B(n1591), .Y(n2057) );
  NAND2XL U2059 ( .A(n2057), .B(n2006), .Y(n1537) );
  OAI211XL U2060 ( .A0(n1919), .A1(n2016), .B0(n1538), .C0(n1537), .Y(n1540)
         );
  NOR2X1 U2061 ( .A(n1860), .B(n1944), .Y(n1539) );
  OAI31X1 U2062 ( .A0(n1869), .A1(n2086), .A2(n1998), .B0(n1541), .Y(
        n_tetris_temp[44]) );
  NAND2X1 U2063 ( .A(n1652), .B(n1595), .Y(n1542) );
  NAND2X4 U2064 ( .A(n2068), .B(n1901), .Y(n2073) );
  OAI2BB1X1 U2065 ( .A0N(n1610), .A1N(n1543), .B0(n1652), .Y(n2087) );
  AOI22XL U2066 ( .A0(tetris_temp[62]), .A1(n2083), .B0(n2082), .B1(
        tetris_temp[68]), .Y(n1547) );
  OAI31XL U2067 ( .A0(n2087), .A1(n2086), .A2(n1998), .B0(n1547), .Y(n1549) );
  OAI22XL U2068 ( .A0(n2117), .A1(n1999), .B0(n1901), .B1(n2016), .Y(n1548) );
  AOI211X1 U2069 ( .A0(n2013), .A1(n2073), .B0(n1549), .C0(n1548), .Y(n1550)
         );
  AOI22XL U2070 ( .A0(tetris_temp[63]), .A1(n2083), .B0(n2082), .B1(
        tetris_temp[69]), .Y(n1554) );
  OAI31XL U2071 ( .A0(n2087), .A1(n2086), .A2(n1973), .B0(n1554), .Y(n1570) );
  NAND2XL U2072 ( .A(n1564), .B(n1563), .Y(n1565) );
  AOI22XL U2073 ( .A0(tetris_temp[65]), .A1(n2083), .B0(n2082), .B1(
        tetris_temp[71]), .Y(n1573) );
  OAI31XL U2074 ( .A0(n2087), .A1(n2086), .A2(n1984), .B0(n1573), .Y(n1575) );
  AOI211X1 U2075 ( .A0(n2021), .A1(n2073), .B0(n1575), .C0(n1574), .Y(n1576)
         );
  NAND2X2 U2076 ( .A(n1037), .B(n1808), .Y(n1578) );
  NOR2X4 U2077 ( .A(n1578), .B(n1577), .Y(n1951) );
  INVX1 U2078 ( .A(n1951), .Y(n1819) );
  NAND2X2 U2079 ( .A(n1783), .B(n1808), .Y(n2137) );
  AOI2BB1X1 U2080 ( .A0N(n1819), .A1N(n1923), .B0(n1579), .Y(n1585) );
  NAND2X4 U2081 ( .A(n1064), .B(n1596), .Y(n1811) );
  NOR2X4 U2082 ( .A(n1439), .B(n1811), .Y(n1792) );
  NAND2XL U2083 ( .A(n1808), .B(n1580), .Y(n1930) );
  NOR2XL U2084 ( .A(n1811), .B(n1209), .Y(n1581) );
  NAND2X2 U2085 ( .A(n1583), .B(n1582), .Y(n2131) );
  NAND2XL U2086 ( .A(n2131), .B(n2040), .Y(n1584) );
  NOR2X4 U2087 ( .A(n1792), .B(n1951), .Y(n1937) );
  NAND2XL U2088 ( .A(n1587), .B(n1586), .Y(n1589) );
  NAND2XL U2089 ( .A(n1765), .B(n2008), .Y(n1590) );
  AOI22XL U2090 ( .A0(tetris_temp[21]), .A1(n1883), .B0(n1882), .B1(
        tetris_temp[15]), .Y(n1593) );
  AOI2BB1X1 U2091 ( .A0N(n1937), .A1N(n2140), .B0(n1594), .Y(n1601) );
  INVX4 U2092 ( .A(n1597), .Y(n1770) );
  NAND2XL U2093 ( .A(n1596), .B(n1768), .Y(n1635) );
  AND2X1 U2094 ( .A(n1958), .B(n2058), .Y(n1745) );
  NAND2X1 U2095 ( .A(n2130), .B(n1881), .Y(n1600) );
  OAI211X1 U2096 ( .A0(n1890), .A1(n2133), .B0(n1600), .C0(n1601), .Y(
        n_tetris_temp[21]) );
  AOI22XL U2097 ( .A0(tetris_temp[19]), .A1(n1883), .B0(n1882), .B1(
        tetris_temp[13]), .Y(n1603) );
  NAND2BXL U2098 ( .AN(n1725), .B(n2039), .Y(n1602) );
  OAI211X1 U2099 ( .A0(n1886), .A1(n2046), .B0(n1603), .C0(n1602), .Y(n1604)
         );
  AOI2BB1X1 U2100 ( .A0N(n1937), .A1N(n2025), .B0(n1604), .Y(n1605) );
  AND2X1 U2101 ( .A(tetris_valid), .B(tetris_temp[22]), .Y(tetris[64]) );
  INVX2 U2102 ( .A(n2057), .Y(n1744) );
  NAND2X1 U2103 ( .A(n1744), .B(n1957), .Y(n1718) );
  AOI22XL U2104 ( .A0(n2021), .A1(n1718), .B0(n2073), .B1(n2019), .Y(n1620) );
  AOI31X1 U2105 ( .A0(n1608), .A1(n1652), .A2(n1662), .B0(n1964), .Y(n2070) );
  NAND2X1 U2106 ( .A(n2070), .B(n1209), .Y(n1717) );
  AOI21XL U2107 ( .A0(n1652), .A1(n1610), .B0(n1609), .Y(n1611) );
  NAND2XL U2108 ( .A(n999), .B(n1981), .Y(n1617) );
  AOI22XL U2109 ( .A0(n2075), .A1(tetris_temp[53]), .B0(n2074), .B1(
        tetris_temp[59]), .Y(n1616) );
  OAI211XL U2110 ( .A0(n2068), .A1(n1915), .B0(n1617), .C0(n1616), .Y(n1618)
         );
  AOI31XL U2111 ( .A0(n1717), .A1(n2018), .A2(n1716), .B0(n1618), .Y(n1619) );
  NAND2XL U2112 ( .A(n1620), .B(n1619), .Y(n_tetris_temp[59]) );
  INVXL U2113 ( .A(score_temp[0]), .Y(n1631) );
  AOI211XL U2114 ( .A0(n1622), .A1(n1631), .B0(tetris_valid), .C0(n1623), .Y(
        n_score_temp[0]) );
  NOR3XL U2115 ( .A(n1624), .B(tetris_valid), .C(n1626), .Y(n_score_temp[1])
         );
  AOI211XL U2116 ( .A0(score_temp[2]), .A1(n1626), .B0(tetris_valid), .C0(
        n1625), .Y(n_score_temp[2]) );
  INVXL U2117 ( .A(cnt[1]), .Y(n1630) );
  AOI22XL U2118 ( .A0(cnt[1]), .A1(n2159), .B0(n2161), .B1(n1630), .Y(n_cnt[1]) );
  OAI21XL U2119 ( .A0(cnt[1]), .A1(tetris_valid), .B0(n2159), .Y(n1627) );
  INVXL U2120 ( .A(n1627), .Y(n1629) );
  INVXL U2121 ( .A(cnt[2]), .Y(n1628) );
  OAI32XL U2122 ( .A0(cnt[2]), .A1(n1630), .A2(n2161), .B0(n1629), .B1(n1628), 
        .Y(n_cnt[2]) );
  INVX2 U2123 ( .A(n1808), .Y(n2134) );
  OAI22XL U2124 ( .A0(n1811), .A1(n1931), .B0(n1209), .B1(n2134), .Y(n1633) );
  AOI31X1 U2125 ( .A0(n1783), .A1(n990), .A2(n2058), .B0(n1633), .Y(n1634) );
  INVX4 U2126 ( .A(n1937), .Y(n1954) );
  AOI21XL U2127 ( .A0(n2046), .A1(n2025), .B0(n2141), .Y(n1641) );
  AOI22XL U2128 ( .A0(n1949), .A1(tetris_temp[1]), .B0(n1948), .B1(
        tetris_temp[7]), .Y(n1639) );
  AOI211X1 U2129 ( .A0(n1954), .A1(n2041), .B0(n1641), .C0(n1640), .Y(n1642)
         );
  AOI21XL U2130 ( .A0(n2024), .A1(n1978), .B0(n2141), .Y(n1645) );
  AOI22XL U2131 ( .A0(n1949), .A1(tetris_temp[5]), .B0(n1948), .B1(
        tetris_temp[11]), .Y(n1643) );
  AOI211X1 U2132 ( .A0(n1954), .A1(n2019), .B0(n1645), .C0(n1644), .Y(n1646)
         );
  NOR2X2 U2133 ( .A(n1961), .B(n1960), .Y(n2125) );
  INVX1 U2134 ( .A(n2125), .Y(n1650) );
  OAI22X1 U2135 ( .A0(n2004), .A1(n1651), .B0(n1209), .B1(n1650), .Y(n2128) );
  OAI22XL U2136 ( .A0(n2117), .A1(n2024), .B0(n1915), .B1(n2114), .Y(n1658) );
  AOI22XL U2137 ( .A0(n2119), .A1(tetris_temp[71]), .B0(tetris_temp[77]), .B1(
        n2118), .Y(n1656) );
  OAI2BB1X1 U2138 ( .A0N(n2021), .A1N(n2121), .B0(n1656), .Y(n1657) );
  OAI2BB1X1 U2139 ( .A0N(n2018), .A1N(n2128), .B0(n1659), .Y(n_tetris_temp[77]) );
  AOI21XL U2140 ( .A0(n2026), .A1(n1500), .B0(n1209), .Y(n1660) );
  AOI31X1 U2141 ( .A0(n1770), .A1(n2056), .A2(n1958), .B0(n1660), .Y(n1661) );
  INVX1 U2142 ( .A(n1811), .Y(n1816) );
  AOI22XL U2143 ( .A0(n1684), .A1(tetris_temp[19]), .B0(n1762), .B1(
        tetris_temp[25]), .Y(n1663) );
  OAI21XL U2144 ( .A0(n1500), .A1(n1923), .B0(n1663), .Y(n1664) );
  AOI211X1 U2145 ( .A0(n2043), .A1(n1816), .B0(n1665), .C0(n1664), .Y(n1666)
         );
  OAI2BB1X1 U2146 ( .A0N(n2040), .A1N(n1774), .B0(n1666), .Y(n_tetris_temp[25]) );
  AOI22XL U2147 ( .A0(n1684), .A1(tetris_temp[21]), .B0(n1762), .B1(
        tetris_temp[27]), .Y(n1667) );
  OAI21XL U2148 ( .A0(n1500), .A1(n2133), .B0(n1667), .Y(n1668) );
  AOI211X1 U2149 ( .A0(n2049), .A1(n1816), .B0(n1669), .C0(n1668), .Y(n1670)
         );
  OAI22XL U2150 ( .A0(n1786), .A1(n2016), .B0(n1999), .B1(n1892), .Y(n1673) );
  AOI22XL U2151 ( .A0(n1684), .A1(tetris_temp[20]), .B0(n1762), .B1(
        tetris_temp[26]), .Y(n1671) );
  OAI21XL U2152 ( .A0(n1500), .A1(n1944), .B0(n1671), .Y(n1672) );
  AOI22XL U2153 ( .A0(n1684), .A1(tetris_temp[23]), .B0(n1762), .B1(
        tetris_temp[29]), .Y(n1675) );
  OAI21XL U2154 ( .A0(n1500), .A1(n1917), .B0(n1675), .Y(n1676) );
  AOI211X1 U2155 ( .A0(n2021), .A1(n1816), .B0(n1677), .C0(n1676), .Y(n1678)
         );
  INVXL U2156 ( .A(n2052), .Y(n1970) );
  NAND2XL U2157 ( .A(n999), .B(n1970), .Y(n1680) );
  AOI22XL U2158 ( .A0(n2075), .A1(tetris_temp[51]), .B0(n2074), .B1(
        tetris_temp[57]), .Y(n1679) );
  OAI211XL U2159 ( .A0(n2068), .A1(n2136), .B0(n1680), .C0(n1679), .Y(n1681)
         );
  AOI31XL U2160 ( .A0(n1717), .A1(n2130), .A2(n1716), .B0(n1681), .Y(n1683) );
  AOI22XL U2161 ( .A0(n2049), .A1(n1718), .B0(n2073), .B1(n1572), .Y(n1682) );
  NAND2XL U2162 ( .A(n1683), .B(n1682), .Y(n_tetris_temp[57]) );
  AOI22XL U2163 ( .A0(n1684), .A1(tetris_temp[22]), .B0(n1762), .B1(
        tetris_temp[28]), .Y(n1685) );
  OAI21XL U2164 ( .A0(n1500), .A1(n1874), .B0(n1685), .Y(n1686) );
  AOI211X1 U2165 ( .A0(n2122), .A1(n1816), .B0(n1687), .C0(n1686), .Y(n1688)
         );
  OAI2BB1X1 U2166 ( .A0N(n2129), .A1N(n1774), .B0(n1688), .Y(n_tetris_temp[28]) );
  AOI22XL U2167 ( .A0(n1808), .A1(n2126), .B0(tetris_temp[4]), .B1(n2132), .Y(
        n1689) );
  OAI21XL U2168 ( .A0(n2137), .A1(n2115), .B0(n1689), .Y(n1690) );
  AOI2BB1X1 U2169 ( .A0N(n2141), .A1N(n1985), .B0(n1690), .Y(n1691) );
  OAI2BB1X1 U2170 ( .A0N(n2129), .A1N(n2131), .B0(n1691), .Y(n_tetris_temp[4])
         );
  AOI22XL U2171 ( .A0(n1808), .A1(n2019), .B0(tetris_temp[5]), .B1(n2132), .Y(
        n1692) );
  OAI21XL U2172 ( .A0(n2137), .A1(n1915), .B0(n1692), .Y(n1693) );
  AOI2BB1X1 U2173 ( .A0N(n2141), .A1N(n1978), .B0(n1693), .Y(n1694) );
  AOI22XL U2174 ( .A0(tetris_temp[61]), .A1(n2083), .B0(n2082), .B1(
        tetris_temp[67]), .Y(n1695) );
  OAI31XL U2175 ( .A0(n2087), .A1(n2086), .A2(n2032), .B0(n1695), .Y(n1697) );
  OAI22XL U2176 ( .A0(n2117), .A1(n2034), .B0(n1901), .B1(n2046), .Y(n1696) );
  AOI211X1 U2177 ( .A0(n2043), .A1(n2073), .B0(n1697), .C0(n1696), .Y(n1698)
         );
  OAI2BB1XL U2178 ( .A0N(n2041), .A1N(n988), .B0(n1698), .Y(n_tetris_temp[67])
         );
  AOI22XL U2179 ( .A0(tetris_temp[64]), .A1(n2083), .B0(n2082), .B1(
        tetris_temp[70]), .Y(n1699) );
  OAI31XL U2180 ( .A0(n2087), .A1(n2086), .A2(n1991), .B0(n1699), .Y(n1701) );
  OAI22XL U2181 ( .A0(n2117), .A1(n2115), .B0(n1901), .B1(n2116), .Y(n1700) );
  AOI211X1 U2182 ( .A0(n2122), .A1(n2073), .B0(n1701), .C0(n1700), .Y(n1702)
         );
  NAND2XL U2183 ( .A(n999), .B(n2029), .Y(n1704) );
  AOI22XL U2184 ( .A0(n2075), .A1(tetris_temp[49]), .B0(n2074), .B1(
        tetris_temp[55]), .Y(n1703) );
  OAI211XL U2185 ( .A0(n2068), .A1(n2034), .B0(n1704), .C0(n1703), .Y(n1705)
         );
  AOI31XL U2186 ( .A0(n1717), .A1(n2040), .A2(n1716), .B0(n1705), .Y(n1707) );
  AOI22XL U2187 ( .A0(n2043), .A1(n1718), .B0(n2073), .B1(n2041), .Y(n1706) );
  NAND2XL U2188 ( .A(n1707), .B(n1706), .Y(n_tetris_temp[55]) );
  NAND2XL U2189 ( .A(n999), .B(n1995), .Y(n1709) );
  AOI22XL U2190 ( .A0(n2075), .A1(tetris_temp[50]), .B0(n2074), .B1(
        tetris_temp[56]), .Y(n1708) );
  OAI211XL U2191 ( .A0(n2068), .A1(n1999), .B0(n1709), .C0(n1708), .Y(n1710)
         );
  AOI31XL U2192 ( .A0(n1717), .A1(n2007), .A2(n1716), .B0(n1710), .Y(n1712) );
  AOI22XL U2193 ( .A0(n2013), .A1(n1718), .B0(n2073), .B1(n1551), .Y(n1711) );
  NAND2XL U2194 ( .A(n1711), .B(n1712), .Y(n_tetris_temp[56]) );
  NAND2XL U2195 ( .A(n999), .B(n1988), .Y(n1714) );
  AOI22XL U2196 ( .A0(n2075), .A1(tetris_temp[52]), .B0(n2074), .B1(
        tetris_temp[58]), .Y(n1713) );
  OAI211XL U2197 ( .A0(n2068), .A1(n2115), .B0(n1714), .C0(n1713), .Y(n1715)
         );
  AOI31XL U2198 ( .A0(n1717), .A1(n2129), .A2(n1716), .B0(n1715), .Y(n1720) );
  AOI22XL U2199 ( .A0(n2122), .A1(n1718), .B0(n2073), .B1(n2126), .Y(n1719) );
  NAND2XL U2200 ( .A(n1719), .B(n1720), .Y(n_tetris_temp[58]) );
  AOI21XL U2201 ( .A0(n2052), .A1(n2140), .B0(n2141), .Y(n1723) );
  AOI22XL U2202 ( .A0(n1949), .A1(tetris_temp[3]), .B0(n1948), .B1(
        tetris_temp[9]), .Y(n1721) );
  AOI211XL U2203 ( .A0(n1954), .A1(n1572), .B0(n1723), .C0(n1722), .Y(n1724)
         );
  AOI22XL U2204 ( .A0(tetris_temp[16]), .A1(n1882), .B0(n1883), .B1(
        tetris_temp[22]), .Y(n1727) );
  NAND2XL U2205 ( .A(n1928), .B(n2100), .Y(n1726) );
  OAI211X1 U2206 ( .A0(n1886), .A1(n2116), .B0(n1727), .C0(n1726), .Y(n1729)
         );
  NOR2XL U2207 ( .A(n1823), .B(n1874), .Y(n1728) );
  AOI211X1 U2208 ( .A0(n1954), .A1(n2122), .B0(n1729), .C0(n1728), .Y(n1730)
         );
  OAI2BB1X1 U2209 ( .A0N(n2129), .A1N(n1881), .B0(n1730), .Y(n_tetris_temp[22]) );
  AOI22XL U2210 ( .A0(tetris_temp[17]), .A1(n1882), .B0(n1883), .B1(
        tetris_temp[23]), .Y(n1732) );
  NAND2XL U2211 ( .A(n1928), .B(n2017), .Y(n1731) );
  OAI211X1 U2212 ( .A0(n1886), .A1(n2024), .B0(n1732), .C0(n1731), .Y(n1734)
         );
  NOR2XL U2213 ( .A(n1823), .B(n1917), .Y(n1733) );
  AOI211X1 U2214 ( .A0(n1954), .A1(n2021), .B0(n1734), .C0(n1733), .Y(n1735)
         );
  OAI2BB1X1 U2215 ( .A0N(n2018), .A1N(n1881), .B0(n1735), .Y(n_tetris_temp[23]) );
  AOI22XL U2216 ( .A0(tetris_temp[60]), .A1(n1903), .B0(n1902), .B1(
        tetris_temp[54]), .Y(n1741) );
  NOR2XL U2217 ( .A(n1739), .B(n1738), .Y(n2094) );
  NAND2XL U2218 ( .A(n2121), .B(n2094), .Y(n1740) );
  OAI211XL U2219 ( .A0(n2068), .A1(n2113), .B0(n1741), .C0(n1740), .Y(n1742)
         );
  AOI2BB1X1 U2220 ( .A0N(n2098), .A1N(n1901), .B0(n1742), .Y(n1743) );
  NOR2X1 U2221 ( .A(n1744), .B(n2053), .Y(n1746) );
  AOI211X2 U2222 ( .A0(n999), .A1(n2056), .B0(n1746), .C0(n1745), .Y(n1927) );
  AOI22XL U2223 ( .A0(n1921), .A1(tetris_temp[39]), .B0(tetris_temp[33]), .B1(
        n1920), .Y(n1749) );
  OAI21XL U2224 ( .A0(n1038), .A1(n2133), .B0(n1749), .Y(n1750) );
  OAI21XL U2225 ( .A0(n1927), .A1(n1973), .B0(n1752), .Y(n_tetris_temp[39]) );
  AOI22XL U2226 ( .A0(tetris_temp[63]), .A1(n1903), .B0(n1902), .B1(
        tetris_temp[57]), .Y(n1753) );
  OAI2BB1X1 U2227 ( .A0N(n1572), .A1N(n2121), .B0(n1753), .Y(n1754) );
  AOI211X1 U2228 ( .A0(n2049), .A1(n2064), .B0(n1755), .C0(n1754), .Y(n1756)
         );
  OAI31XL U2229 ( .A0(n1909), .A1(n1908), .A2(n1973), .B0(n1756), .Y(
        n_tetris_temp[63]) );
  INVX1 U2230 ( .A(n1860), .Y(n1760) );
  NAND2XL U2231 ( .A(n2057), .B(n2090), .Y(n1758) );
  AOI22XL U2232 ( .A0(n1862), .A1(tetris_temp[36]), .B0(n1861), .B1(
        tetris_temp[42]), .Y(n1757) );
  OAI211XL U2233 ( .A0(n1919), .A1(n2113), .B0(n1758), .C0(n1757), .Y(n1759)
         );
  AOI21XL U2234 ( .A0(n1760), .A1(n2094), .B0(n1759), .Y(n1761) );
  OAI31XL U2235 ( .A0(n1869), .A1(n2086), .A2(n2085), .B0(n1761), .Y(
        n_tetris_temp[42]) );
  NOR2XL U2236 ( .A(n1892), .B(n2113), .Y(n1767) );
  OAI22XL U2237 ( .A0(n1894), .A1(n2158), .B0(n1893), .B1(n2202), .Y(n1766) );
  NAND2XL U2238 ( .A(n1774), .B(n2105), .Y(n1780) );
  NOR2XL U2239 ( .A(n1892), .B(n2098), .Y(n1778) );
  OAI22XL U2240 ( .A0(n1776), .A1(n2208), .B0(n2202), .B1(n1775), .Y(n1777) );
  NAND3X1 U2241 ( .A(n1783), .B(n990), .C(n1782), .Y(n1784) );
  OAI211X2 U2242 ( .A0(n2053), .A1(n1786), .B0(n1785), .C0(n1784), .Y(n1822)
         );
  NOR2XL U2243 ( .A(n1886), .B(n1915), .Y(n1790) );
  AOI22XL U2244 ( .A0(n1949), .A1(tetris_temp[11]), .B0(n1948), .B1(
        tetris_temp[17]), .Y(n1788) );
  NAND2XL U2245 ( .A(n1808), .B(n2021), .Y(n1787) );
  BUFX2 U2246 ( .A(n1792), .Y(n1814) );
  AOI22XL U2247 ( .A0(n1949), .A1(tetris_temp[9]), .B0(n1948), .B1(
        tetris_temp[15]), .Y(n1794) );
  NAND2XL U2248 ( .A(n1808), .B(n2049), .Y(n1793) );
  NOR2XL U2249 ( .A(n1819), .B(n2016), .Y(n1801) );
  AOI22XL U2250 ( .A0(n1949), .A1(tetris_temp[8]), .B0(n1948), .B1(
        tetris_temp[14]), .Y(n1799) );
  NAND2XL U2251 ( .A(n1808), .B(n2013), .Y(n1798) );
  AOI22XL U2252 ( .A0(n1949), .A1(tetris_temp[10]), .B0(n1948), .B1(
        tetris_temp[16]), .Y(n1804) );
  NAND2XL U2253 ( .A(n1808), .B(n2122), .Y(n1803) );
  NOR2XL U2254 ( .A(n1819), .B(n2046), .Y(n1813) );
  AOI22XL U2255 ( .A0(n1949), .A1(tetris_temp[7]), .B0(n1948), .B1(
        tetris_temp[13]), .Y(n1810) );
  NAND2XL U2256 ( .A(n1808), .B(n2043), .Y(n1809) );
  AOI22XL U2257 ( .A0(n1949), .A1(tetris_temp[6]), .B0(n1948), .B1(
        tetris_temp[12]), .Y(n1818) );
  NAND2XL U2258 ( .A(n1816), .B(n2094), .Y(n1817) );
  OAI211XL U2259 ( .A0(n1819), .A1(n2113), .B0(n1818), .C0(n1817), .Y(n1820)
         );
  AOI2BB1X1 U2260 ( .A0N(n1886), .A1N(n2098), .B0(n1820), .Y(n1821) );
  NOR2XL U2261 ( .A(n1892), .B(n2046), .Y(n1825) );
  OAI22XL U2262 ( .A0(n1894), .A1(n2197), .B0(n1893), .B1(n2203), .Y(n1824) );
  AOI211X1 U2263 ( .A0(n1897), .A1(n2039), .B0(n1825), .C0(n1824), .Y(n1826)
         );
  OAI211XL U2264 ( .A0(n1900), .A1(n1923), .B0(n1827), .C0(n1826), .Y(
        n_tetris_temp[31]) );
  OAI22XL U2265 ( .A0(n1894), .A1(n2198), .B0(n1893), .B1(n2204), .Y(n1829) );
  AOI211X1 U2266 ( .A0(n1897), .A1(n2006), .B0(n1830), .C0(n1829), .Y(n1831)
         );
  OAI22XL U2267 ( .A0(n1894), .A1(n2199), .B0(n1893), .B1(n2205), .Y(n1833) );
  AOI211X1 U2268 ( .A0(n1897), .A1(n2047), .B0(n1834), .C0(n1833), .Y(n1835)
         );
  AOI22XL U2269 ( .A0(n1862), .A1(tetris_temp[41]), .B0(n1861), .B1(
        tetris_temp[47]), .Y(n1838) );
  NAND2XL U2270 ( .A(n2057), .B(n2017), .Y(n1837) );
  AOI211X1 U2271 ( .A0(n1867), .A1(n2021), .B0(n1840), .C0(n1839), .Y(n1841)
         );
  OAI31XL U2272 ( .A0(n1869), .A1(n2086), .A2(n1984), .B0(n1841), .Y(
        n_tetris_temp[47]) );
  AOI22XL U2273 ( .A0(n1921), .A1(tetris_temp[38]), .B0(tetris_temp[32]), .B1(
        n1920), .Y(n1842) );
  OAI21XL U2274 ( .A0(n1038), .A1(n1944), .B0(n1842), .Y(n1843) );
  AOI211XL U2275 ( .A0(n990), .A1(n2013), .B0(n1844), .C0(n1843), .Y(n1845) );
  OAI21XL U2276 ( .A0(n1927), .A1(n1998), .B0(n1845), .Y(n_tetris_temp[38]) );
  OAI22XL U2277 ( .A0(n2004), .A1(n2116), .B0(n2115), .B1(n1919), .Y(n1848) );
  AOI22XL U2278 ( .A0(n1921), .A1(tetris_temp[40]), .B0(tetris_temp[34]), .B1(
        n1920), .Y(n1846) );
  OAI21XL U2279 ( .A0(n1038), .A1(n1874), .B0(n1846), .Y(n1847) );
  AOI211X1 U2280 ( .A0(n990), .A1(n2122), .B0(n1848), .C0(n1847), .Y(n1849) );
  OAI21XL U2281 ( .A0(n1927), .A1(n1991), .B0(n1849), .Y(n_tetris_temp[40]) );
  NOR2XL U2282 ( .A(n1860), .B(n2133), .Y(n1853) );
  NAND2XL U2283 ( .A(n2057), .B(n2047), .Y(n1851) );
  AOI22XL U2284 ( .A0(n1862), .A1(tetris_temp[39]), .B0(n1861), .B1(
        tetris_temp[45]), .Y(n1850) );
  AOI211X1 U2285 ( .A0(n1867), .A1(n2049), .B0(n1853), .C0(n1852), .Y(n1854)
         );
  OAI31XL U2286 ( .A0(n1869), .A1(n2086), .A2(n1973), .B0(n1854), .Y(
        n_tetris_temp[45]) );
  AOI22XL U2287 ( .A0(n1862), .A1(tetris_temp[40]), .B0(n1861), .B1(
        tetris_temp[46]), .Y(n1856) );
  NAND2XL U2288 ( .A(n2057), .B(n2100), .Y(n1855) );
  OAI211XL U2289 ( .A0(n1919), .A1(n2116), .B0(n1856), .C0(n1855), .Y(n1858)
         );
  AOI211X1 U2290 ( .A0(n1867), .A1(n2122), .B0(n1858), .C0(n1857), .Y(n1859)
         );
  OAI31XL U2291 ( .A0(n1869), .A1(n2086), .A2(n1991), .B0(n1859), .Y(
        n_tetris_temp[46]) );
  NAND2XL U2292 ( .A(n2057), .B(n2039), .Y(n1864) );
  AOI211X1 U2293 ( .A0(n1867), .A1(n2043), .B0(n1865), .C0(n1866), .Y(n1868)
         );
  OAI31XL U2294 ( .A0(n1869), .A1(n2086), .A2(n2032), .B0(n1868), .Y(
        n_tetris_temp[43]) );
  OAI22XL U2295 ( .A0(n1894), .A1(n2200), .B0(n1893), .B1(n2206), .Y(n1870) );
  AOI211X1 U2296 ( .A0(n1897), .A1(n2100), .B0(n1871), .C0(n1870), .Y(n1872)
         );
  NAND2XL U2297 ( .A(n2105), .B(n1881), .Y(n1880) );
  INVXL U2298 ( .A(n1883), .Y(n1876) );
  OAI22XL U2299 ( .A0(n1876), .A1(n2208), .B0(n1875), .B1(n2213), .Y(n1877) );
  AOI211X1 U2300 ( .A0(n2090), .A1(n1928), .B0(n1878), .C0(n1877), .Y(n1879)
         );
  OAI211XL U2301 ( .A0(n2093), .A1(n1890), .B0(n1880), .C0(n1879), .Y(
        n_tetris_temp[18]) );
  NAND2XL U2302 ( .A(n1881), .B(n2007), .Y(n1889) );
  AOI22XL U2303 ( .A0(tetris_temp[20]), .A1(n1883), .B0(n1882), .B1(
        tetris_temp[14]), .Y(n1885) );
  AOI2BB1X1 U2304 ( .A0N(n1937), .A1N(n1992), .B0(n1887), .Y(n1888) );
  OAI211X1 U2305 ( .A0(n1944), .A1(n1890), .B0(n1889), .C0(n1888), .Y(
        n_tetris_temp[20]) );
  OAI22XL U2306 ( .A0(n1894), .A1(n2201), .B0(n1893), .B1(n2207), .Y(n1895) );
  AOI211X1 U2307 ( .A0(n1897), .A1(n2017), .B0(n1896), .C0(n1895), .Y(n1898)
         );
  OAI211XL U2308 ( .A0(n1900), .A1(n1917), .B0(n1899), .C0(n1898), .Y(
        n_tetris_temp[35]) );
  OAI22XL U2309 ( .A0(n2068), .A1(n2016), .B0(n1999), .B1(n1901), .Y(n1906) );
  AOI22XL U2310 ( .A0(tetris_temp[62]), .A1(n1903), .B0(n1902), .B1(
        tetris_temp[56]), .Y(n1904) );
  OAI2BB1X1 U2311 ( .A0N(n1551), .A1N(n2121), .B0(n1904), .Y(n1905) );
  OAI31XL U2312 ( .A0(n1909), .A1(n1908), .A2(n1998), .B0(n1907), .Y(
        n_tetris_temp[62]) );
  AOI22XL U2313 ( .A0(n1921), .A1(tetris_temp[36]), .B0(n1920), .B1(
        tetris_temp[30]), .Y(n1912) );
  NAND2XL U2314 ( .A(n1910), .B(n2094), .Y(n1911) );
  OAI211XL U2315 ( .A0(n2004), .A1(n2113), .B0(n1912), .C0(n1911), .Y(n1913)
         );
  AOI2BB1X1 U2316 ( .A0N(n1919), .A1N(n2098), .B0(n1913), .Y(n1914) );
  OAI21XL U2317 ( .A0(n1927), .A1(n2085), .B0(n1914), .Y(n_tetris_temp[36]) );
  AOI22XL U2318 ( .A0(n1921), .A1(tetris_temp[41]), .B0(tetris_temp[35]), .B1(
        n1920), .Y(n1916) );
  OAI21XL U2319 ( .A0(n1038), .A1(n1917), .B0(n1916), .Y(n1918) );
  OAI22XL U2320 ( .A0(n2004), .A1(n2046), .B0(n2034), .B1(n1919), .Y(n1925) );
  AOI22XL U2321 ( .A0(n1921), .A1(tetris_temp[37]), .B0(tetris_temp[31]), .B1(
        n1920), .Y(n1922) );
  OAI21XL U2322 ( .A0(n1038), .A1(n1923), .B0(n1922), .Y(n1924) );
  AOI211X1 U2323 ( .A0(n990), .A1(n2043), .B0(n1925), .C0(n1924), .Y(n1926) );
  OAI21XL U2324 ( .A0(n1927), .A1(n2032), .B0(n1926), .Y(n_tetris_temp[37]) );
  NAND2XL U2325 ( .A(n2058), .B(n1928), .Y(n1929) );
  OAI211XL U2326 ( .A0(n1937), .A1(n1931), .B0(n1930), .C0(n1929), .Y(n1932)
         );
  NAND2XL U2327 ( .A(n1932), .B(n2105), .Y(n1934) );
  AOI22XL U2328 ( .A0(n1951), .A1(n2094), .B0(tetris_temp[0]), .B1(n2132), .Y(
        n1933) );
  OAI211XL U2329 ( .A0(n2137), .A1(n2098), .B0(n1934), .C0(n1933), .Y(
        n_tetris_temp[0]) );
  NAND2XL U2330 ( .A(n1951), .B(n2090), .Y(n1936) );
  AOI22XL U2331 ( .A0(n1949), .A1(tetris_temp[0]), .B0(n1948), .B1(
        tetris_temp[6]), .Y(n1935) );
  OAI211XL U2332 ( .A0(n1937), .A1(n2093), .B0(n1936), .C0(n1935), .Y(n1938)
         );
  AOI2BB1X1 U2333 ( .A0N(n2113), .A1N(n2141), .B0(n1938), .Y(n1939) );
  OAI2BB1X1 U2334 ( .A0N(n2105), .A1N(n1956), .B0(n1939), .Y(n_tetris_temp[6])
         );
  AOI21XL U2335 ( .A0(n2116), .A1(n1985), .B0(n2141), .Y(n1942) );
  AOI22XL U2336 ( .A0(n1949), .A1(tetris_temp[4]), .B0(n1948), .B1(
        tetris_temp[10]), .Y(n1940) );
  AOI211X1 U2337 ( .A0(n1954), .A1(n2126), .B0(n1942), .C0(n1941), .Y(n1943)
         );
  NAND2XL U2338 ( .A(n2131), .B(n2007), .Y(n1947) );
  OAI2BB2XL U2339 ( .B0(n2134), .B1(n1944), .A0N(tetris_temp[2]), .A1N(n2132), 
        .Y(n1945) );
  AOI2BB1X1 U2340 ( .A0N(n2137), .A1N(n1999), .B0(n1945), .Y(n1946) );
  OAI211XL U2341 ( .A0(n2141), .A1(n1992), .B0(n1947), .C0(n1946), .Y(
        n_tetris_temp[2]) );
  AOI21XL U2342 ( .A0(n2016), .A1(n1992), .B0(n2141), .Y(n1953) );
  AOI22XL U2343 ( .A0(n1949), .A1(tetris_temp[2]), .B0(n1948), .B1(
        tetris_temp[8]), .Y(n1950) );
  AOI211XL U2344 ( .A0(n1954), .A1(n1551), .B0(n1953), .C0(n1952), .Y(n1955)
         );
  NOR2XL U2345 ( .A(n1961), .B(n1958), .Y(n1959) );
  AOI211XL U2346 ( .A0(n1961), .A1(n1960), .B0(n1959), .C0(n1209), .Y(n1966)
         );
  OAI22XL U2347 ( .A0(n2061), .A1(n2189), .B0(n2183), .B1(n2060), .Y(n1968) );
  AOI211XL U2348 ( .A0(n2064), .A1(n1572), .B0(n1969), .C0(n1968), .Y(n1972)
         );
  AOI22XL U2349 ( .A0(n999), .A1(n2047), .B0(n2057), .B1(n1970), .Y(n1971) );
  OAI211XL U2350 ( .A0(n2033), .A1(n1973), .B0(n1972), .C0(n1971), .Y(
        n_tetris_temp[51]) );
  OAI22XL U2351 ( .A0(n2117), .A1(n2052), .B0(n2136), .B1(n2114), .Y(n1976) );
  AOI22XL U2352 ( .A0(n2119), .A1(tetris_temp[69]), .B0(tetris_temp[75]), .B1(
        n2118), .Y(n1974) );
  OAI2BB1X1 U2353 ( .A0N(n2049), .A1N(n2121), .B0(n1974), .Y(n1975) );
  AOI211XL U2354 ( .A0(n1572), .A1(n2125), .B0(n1976), .C0(n1975), .Y(n1977)
         );
  OAI2BB1X1 U2355 ( .A0N(n2130), .A1N(n2128), .B0(n1977), .Y(n_tetris_temp[75]) );
  OAI22XL U2356 ( .A0(n2061), .A1(n2191), .B0(n2185), .B1(n2060), .Y(n1979) );
  AOI211XL U2357 ( .A0(n2064), .A1(n2019), .B0(n1980), .C0(n1979), .Y(n1983)
         );
  AOI22XL U2358 ( .A0(n999), .A1(n2017), .B0(n2057), .B1(n1981), .Y(n1982) );
  OAI211XL U2359 ( .A0(n2033), .A1(n1984), .B0(n1983), .C0(n1982), .Y(
        n_tetris_temp[53]) );
  OAI22XL U2360 ( .A0(n2061), .A1(n2190), .B0(n2184), .B1(n2060), .Y(n1986) );
  AOI211XL U2361 ( .A0(n2064), .A1(n2126), .B0(n1987), .C0(n1986), .Y(n1990)
         );
  AOI22XL U2362 ( .A0(n999), .A1(n2100), .B0(n2057), .B1(n1988), .Y(n1989) );
  OAI211XL U2363 ( .A0(n2033), .A1(n1991), .B0(n1990), .C0(n1989), .Y(
        n_tetris_temp[52]) );
  OAI22XL U2364 ( .A0(n2061), .A1(n2188), .B0(n2182), .B1(n2060), .Y(n1993) );
  AOI211XL U2365 ( .A0(n2064), .A1(n1551), .B0(n1994), .C0(n1993), .Y(n1997)
         );
  AOI22XL U2366 ( .A0(n999), .A1(n2006), .B0(n2057), .B1(n1995), .Y(n1996) );
  OAI211XL U2367 ( .A0(n2033), .A1(n1998), .B0(n1997), .C0(n1996), .Y(
        n_tetris_temp[50]) );
  OAI22XL U2368 ( .A0(n2117), .A1(n2016), .B0(n1999), .B1(n2114), .Y(n2002) );
  AOI22XL U2369 ( .A0(n2119), .A1(tetris_temp[68]), .B0(tetris_temp[74]), .B1(
        n2118), .Y(n2000) );
  OAI2BB1X1 U2370 ( .A0N(n2013), .A1N(n2121), .B0(n2000), .Y(n2001) );
  AOI211XL U2371 ( .A0(n1551), .A1(n2125), .B0(n2002), .C0(n2001), .Y(n2003)
         );
  NOR2X2 U2372 ( .A(n2005), .B(n2004), .Y(n2106) );
  OAI31XL U2373 ( .A0(n2007), .A1(n1551), .A2(n2006), .B0(n2106), .Y(n2015) );
  INVXL U2374 ( .A(tetris_temp[74]), .Y(n2149) );
  AOI21XL U2375 ( .A0(n2010), .A1(n2009), .B0(tetris_valid), .Y(n2011) );
  AOI21XL U2376 ( .A0(n2102), .A1(n2013), .B0(n2012), .Y(n2014) );
  OAI211XL U2377 ( .A0(n2114), .A1(n2016), .B0(n2015), .C0(n2014), .Y(
        n_tetris_temp[80]) );
  OAI31XL U2378 ( .A0(n2019), .A1(n2018), .A2(n2017), .B0(n2106), .Y(n2023) );
  INVXL U2379 ( .A(tetris_temp[77]), .Y(n2152) );
  AOI21XL U2380 ( .A0(n2102), .A1(n2021), .B0(n2020), .Y(n2022) );
  OAI211XL U2381 ( .A0(n2024), .A1(n2114), .B0(n2023), .C0(n2022), .Y(
        n_tetris_temp[83]) );
  OAI22XL U2382 ( .A0(n2061), .A1(n2187), .B0(n2181), .B1(n2060), .Y(n2027) );
  AOI211XL U2383 ( .A0(n2064), .A1(n2041), .B0(n2028), .C0(n2027), .Y(n2031)
         );
  AOI22XL U2384 ( .A0(n999), .A1(n2039), .B0(n2057), .B1(n2029), .Y(n2030) );
  OAI211XL U2385 ( .A0(n2033), .A1(n2032), .B0(n2031), .C0(n2030), .Y(
        n_tetris_temp[49]) );
  OAI22XL U2386 ( .A0(n2117), .A1(n2046), .B0(n2034), .B1(n2114), .Y(n2037) );
  AOI22XL U2387 ( .A0(n2119), .A1(tetris_temp[67]), .B0(tetris_temp[73]), .B1(
        n2118), .Y(n2035) );
  OAI2BB1X1 U2388 ( .A0N(n2043), .A1N(n2121), .B0(n2035), .Y(n2036) );
  AOI211X1 U2389 ( .A0(n2041), .A1(n2125), .B0(n2037), .C0(n2036), .Y(n2038)
         );
  OAI31XL U2390 ( .A0(n2041), .A1(n2040), .A2(n2039), .B0(n2106), .Y(n2045) );
  INVXL U2391 ( .A(tetris_temp[73]), .Y(n2148) );
  AOI21XL U2392 ( .A0(n2102), .A1(n2043), .B0(n2042), .Y(n2044) );
  OAI211XL U2393 ( .A0(n2046), .A1(n2114), .B0(n2045), .C0(n2044), .Y(
        n_tetris_temp[79]) );
  OAI31XL U2394 ( .A0(n1572), .A1(n2130), .A2(n2047), .B0(n2106), .Y(n2051) );
  INVXL U2395 ( .A(tetris_temp[75]), .Y(n2150) );
  AOI21XL U2396 ( .A0(n2102), .A1(n2049), .B0(n2048), .Y(n2050) );
  OAI211XL U2397 ( .A0(n2052), .A1(n2114), .B0(n2051), .C0(n2050), .Y(
        n_tetris_temp[81]) );
  NOR3XL U2398 ( .A(n2068), .B(n2053), .C(n2085), .Y(n2054) );
  AOI31XL U2399 ( .A0(n2105), .A1(n2056), .A2(n2055), .B0(n2054), .Y(n2067) );
  AOI22XL U2400 ( .A0(n999), .A1(n2090), .B0(n2057), .B1(n2076), .Y(n2066) );
  NAND2XL U2401 ( .A(n2069), .B(n2093), .Y(n2072) );
  INVXL U2402 ( .A(n2121), .Y(n2059) );
  INVXL U2403 ( .A(tetris_temp[48]), .Y(n2156) );
  OAI22XL U2404 ( .A0(n2061), .A1(n2186), .B0(n2156), .B1(n2060), .Y(n2062) );
  AOI211XL U2405 ( .A0(n2064), .A1(n2072), .B0(n2063), .C0(n2062), .Y(n2065)
         );
  NAND3XL U2406 ( .A(n2067), .B(n2066), .C(n2065), .Y(n_tetris_temp[48]) );
  OAI22XL U2407 ( .A0(n2098), .A1(n2068), .B0(n2117), .B1(n2069), .Y(n2080) );
  OAI22XL U2408 ( .A0(n2070), .A1(n2085), .B0(n2069), .B1(n2114), .Y(n2071) );
  AOI21XL U2409 ( .A0(n2073), .A1(n2072), .B0(n2071), .Y(n2079) );
  NAND2XL U2410 ( .A(n999), .B(n2076), .Y(n2077) );
  AOI22XL U2411 ( .A0(n2083), .A1(tetris_temp[60]), .B0(tetris_temp[66]), .B1(
        n2082), .Y(n2084) );
  OAI21XL U2412 ( .A0(n1901), .A1(n2113), .B0(n2084), .Y(n2089) );
  NOR3XL U2413 ( .A(n2087), .B(n2086), .C(n2085), .Y(n2088) );
  AOI211X1 U2414 ( .A0(n996), .A1(n2090), .B0(n2089), .C0(n2088), .Y(n2091) );
  OAI31XL U2415 ( .A0(n1542), .A1(n2093), .A2(n2092), .B0(n2091), .Y(
        n_tetris_temp[66]) );
  AOI22XL U2416 ( .A0(n2119), .A1(tetris_temp[66]), .B0(tetris_temp[72]), .B1(
        n2118), .Y(n2096) );
  NAND2XL U2417 ( .A(n2125), .B(n2094), .Y(n2095) );
  OAI211XL U2418 ( .A0(n2117), .A1(n2113), .B0(n2096), .C0(n2095), .Y(n2097)
         );
  OAI31XL U2419 ( .A0(n2129), .A1(n2126), .A2(n2100), .B0(n2106), .Y(n2104) );
  INVXL U2420 ( .A(tetris_temp[76]), .Y(n2151) );
  AOI21XL U2421 ( .A0(n2102), .A1(n2122), .B0(n2101), .Y(n2103) );
  OAI211XL U2422 ( .A0(n2116), .A1(n2114), .B0(n2104), .C0(n2103), .Y(
        n_tetris_temp[82]) );
  NAND2XL U2423 ( .A(n2106), .B(n2105), .Y(n2112) );
  INVXL U2424 ( .A(n2107), .Y(n2110) );
  INVXL U2425 ( .A(n2108), .Y(n2109) );
  OAI22XL U2426 ( .A0(n2117), .A1(n2116), .B0(n2115), .B1(n2114), .Y(n2124) );
  AOI22XL U2427 ( .A0(n2119), .A1(tetris_temp[70]), .B0(tetris_temp[76]), .B1(
        n2118), .Y(n2120) );
  OAI2BB1X1 U2428 ( .A0N(n2122), .A1N(n2121), .B0(n2120), .Y(n2123) );
  AOI211X1 U2429 ( .A0(n2126), .A1(n2125), .B0(n2124), .C0(n2123), .Y(n2127)
         );
  OAI2BB1X1 U2430 ( .A0N(n2129), .A1N(n2128), .B0(n2127), .Y(n_tetris_temp[76]) );
  NAND2XL U2431 ( .A(n2131), .B(n2130), .Y(n2139) );
  OAI2BB2XL U2432 ( .B0(n2134), .B1(n2133), .A0N(tetris_temp[3]), .A1N(n2132), 
        .Y(n2135) );
  AOI2BB1X1 U2433 ( .A0N(n2137), .A1N(n2136), .B0(n2135), .Y(n2138) );
  OAI211XL U2434 ( .A0(n2141), .A1(n2140), .B0(n2139), .C0(n2138), .Y(
        n_tetris_temp[3]) );
  NOR2X2 U2435 ( .A(n2160), .B(n2142), .Y(tetris[1]) );
  NOR2X2 U2436 ( .A(n2160), .B(n2143), .Y(tetris[2]) );
  NOR2X2 U2437 ( .A(n2160), .B(n2144), .Y(tetris[3]) );
  NOR2X2 U2438 ( .A(n2160), .B(n2145), .Y(tetris[4]) );
  NOR2X2 U2439 ( .A(n2160), .B(n2146), .Y(tetris[5]) );
  INVXL U2440 ( .A(tetris_temp[72]), .Y(n2147) );
  NOR2X2 U2441 ( .A(n2160), .B(n2147), .Y(tetris[6]) );
  NOR2X2 U2442 ( .A(n998), .B(n2148), .Y(tetris[7]) );
  NOR2X2 U2443 ( .A(n2160), .B(n2149), .Y(tetris[8]) );
  NOR2X2 U2444 ( .A(n998), .B(n2150), .Y(tetris[9]) );
  NOR2X2 U2445 ( .A(n2160), .B(n2151), .Y(tetris[10]) );
  NOR2X2 U2446 ( .A(n998), .B(n2152), .Y(tetris[11]) );
  NOR2X2 U2447 ( .A(n2160), .B(n997), .Y(tetris[12]) );
  NOR2X2 U2448 ( .A(n998), .B(n2167), .Y(tetris[13]) );
  NOR2X2 U2449 ( .A(n998), .B(n2168), .Y(tetris[14]) );
  NOR2X2 U2450 ( .A(n998), .B(n2153), .Y(tetris[15]) );
  NOR2X2 U2451 ( .A(n998), .B(n2169), .Y(tetris[16]) );
  NOR2X2 U2452 ( .A(n998), .B(n2170), .Y(tetris[17]) );
  NOR2X2 U2453 ( .A(n998), .B(n2154), .Y(tetris[18]) );
  NOR2X2 U2454 ( .A(n998), .B(n2171), .Y(tetris[19]) );
  NOR2X2 U2455 ( .A(n2160), .B(n2172), .Y(tetris[20]) );
  NOR2X2 U2456 ( .A(n2160), .B(n2173), .Y(tetris[21]) );
  NOR2X2 U2457 ( .A(n2160), .B(n2174), .Y(tetris[22]) );
  NOR2X2 U2458 ( .A(n998), .B(n2175), .Y(tetris[23]) );
  NOR2X2 U2459 ( .A(n2160), .B(n2155), .Y(tetris[24]) );
  NOR2X2 U2460 ( .A(n2160), .B(n2176), .Y(tetris[25]) );
  NOR2X2 U2461 ( .A(n998), .B(n2177), .Y(tetris[26]) );
  NOR2X2 U2462 ( .A(n2160), .B(n2178), .Y(tetris[27]) );
  NOR2X2 U2463 ( .A(n998), .B(n2179), .Y(tetris[28]) );
  NOR2X2 U2464 ( .A(n2160), .B(n2180), .Y(tetris[29]) );
  NOR2X2 U2465 ( .A(n2160), .B(n2156), .Y(tetris[30]) );
  NOR2X2 U2466 ( .A(n998), .B(n2181), .Y(tetris[31]) );
  NOR2X2 U2467 ( .A(n2160), .B(n2182), .Y(tetris[32]) );
  NOR2X2 U2468 ( .A(n998), .B(n2183), .Y(tetris[33]) );
  NOR2X2 U2469 ( .A(n998), .B(n2184), .Y(tetris[34]) );
  NOR2X2 U2470 ( .A(n998), .B(n2185), .Y(tetris[35]) );
  NOR2X2 U2471 ( .A(n998), .B(n2186), .Y(tetris[36]) );
  NOR2X2 U2472 ( .A(n998), .B(n2187), .Y(tetris[37]) );
  NOR2X2 U2473 ( .A(n998), .B(n2188), .Y(tetris[38]) );
  NOR2X2 U2474 ( .A(n998), .B(n2189), .Y(tetris[39]) );
  NOR2X2 U2475 ( .A(n998), .B(n2190), .Y(tetris[40]) );
  NOR2X2 U2476 ( .A(n998), .B(n2191), .Y(tetris[41]) );
  NOR2X2 U2477 ( .A(n998), .B(n2157), .Y(tetris[42]) );
  NOR2X2 U2478 ( .A(n998), .B(n2192), .Y(tetris[43]) );
  NOR2X2 U2479 ( .A(n998), .B(n2193), .Y(tetris[44]) );
  NOR2X2 U2480 ( .A(n2160), .B(n2194), .Y(tetris[45]) );
  NOR2X2 U2481 ( .A(n2160), .B(n2195), .Y(tetris[46]) );
  NOR2X2 U2482 ( .A(n2160), .B(n2196), .Y(tetris[47]) );
  NOR2X2 U2483 ( .A(n2160), .B(n2158), .Y(tetris[48]) );
  NOR2X2 U2484 ( .A(n2160), .B(n2197), .Y(tetris[49]) );
  NOR2X2 U2485 ( .A(n2160), .B(n2198), .Y(tetris[50]) );
  NOR2X2 U2486 ( .A(n2160), .B(n2199), .Y(tetris[51]) );
  NOR2X2 U2487 ( .A(n2160), .B(n2200), .Y(tetris[52]) );
  NOR2X2 U2488 ( .A(n2160), .B(n2201), .Y(tetris[53]) );
  NOR2X2 U2489 ( .A(n2160), .B(n2202), .Y(tetris[54]) );
  NOR2X2 U2490 ( .A(n998), .B(n2203), .Y(tetris[55]) );
  NOR2X2 U2491 ( .A(n2160), .B(n2204), .Y(tetris[56]) );
  NOR2X2 U2492 ( .A(n2160), .B(n2205), .Y(tetris[57]) );
  NOR2X2 U2493 ( .A(n2160), .B(n2206), .Y(tetris[58]) );
  NOR2X2 U2494 ( .A(n2160), .B(n2207), .Y(tetris[59]) );
  NOR2X2 U2495 ( .A(n2160), .B(n2208), .Y(tetris[60]) );
  NOR2X2 U2496 ( .A(n2160), .B(n2209), .Y(tetris[61]) );
  NOR2X2 U2497 ( .A(n2160), .B(n2210), .Y(tetris[62]) );
  NOR2X2 U2498 ( .A(n2160), .B(n2211), .Y(tetris[63]) );
  NOR2X2 U2499 ( .A(n2160), .B(n2212), .Y(tetris[65]) );
  NOR2X2 U2500 ( .A(n2160), .B(n2213), .Y(tetris[66]) );
  NOR2X2 U2501 ( .A(n2160), .B(n2214), .Y(tetris[67]) );
  NOR2X2 U2502 ( .A(n2160), .B(n2215), .Y(tetris[68]) );
  NOR2X2 U2503 ( .A(n2160), .B(n2216), .Y(tetris[69]) );
  NOR2X2 U2504 ( .A(n2160), .B(n2217), .Y(tetris[70]) );
  NOR2X2 U2505 ( .A(n2160), .B(n2218), .Y(tetris[71]) );
  NAND2XL U2506 ( .A(cnt[1]), .B(cnt[2]), .Y(n2162) );
  OAI2BB2XL U2507 ( .B0(n2162), .B1(n2161), .A0N(cnt[3]), .A1N(n2160), .Y(
        n_cnt[3]) );
  INVXL U2508 ( .A(c_state[0]), .Y(n2163) );
  AOI222XL U2509 ( .A0(c_state[1]), .A1(n1017), .B0(c_state[1]), .B1(n2163), 
        .C0(n1017), .C1(n2163), .Y(n986) );
endmodule

