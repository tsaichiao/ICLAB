 
****************************************
Report : resources
Design : BB
Version: T-2022.03
Date   : Mon Sep 23 11:36:37 2024
****************************************


Resource Report for this hierarchy in file ../01_RTL/BB.v
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| gt_x_12        | DW_cmp         | width=5    | gt_150 (BB.v:150)          |
| gt_x_16        | DW_cmp         | width=5    | gt_215 (BB.v:215)          |
| lt_x_17        | DW_cmp         | width=5    | lt_216 (BB.v:216)          |
| gt_x_33        | DW_cmp         | width=3    | gt_135 (BB.v:135)          |
|                |                |            | gt_136 (BB.v:136)          |
| add_x_34       | DW01_add       | width=3    | cal01/add_307 (BB.v:307)   |
|                |                |            | cal01/add_307_2 (BB.v:307) |
| add_x_30       | DW01_inc       | width=3    | cal01/add_306 (BB.v:306)   |
|                |                |            | cal01/add_307 (BB.v:307)   |
|                |                |            | cal01/add_307_2 (BB.v:307) |
|                |                |            | cal01/add_309 (BB.v:309)   |
| DP_OP_106J1_122_486             |            |                            |
|                | DP_OP_106J1_122_486 |       |                            |
=============================================================================

Datapath Report for DP_OP_106J1_122_486
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_106J1_122_486  | cal01/add_253_S2 (BB.v:253)                         |
|                      | cal01/add_261 (BB.v:261)                            |
|                      | cal01/add_260_S2 (BB.v:260)                         |
|                      | cal01/add_260_S2_2 (BB.v:260)                       |
|                      | cal01/add_263 (BB.v:263) cal01/add_263_2 (BB.v:263) |
|                      | cal01/add_264 (BB.v:264) cal01/add_264_2 (BB.v:264) |
|                      | cal01/add_264_3 (BB.v:264) cal01/C265 (BB.v:260)    |
|                      | cal01/C264 (BB.v:253) cal01/C268 (BB.v:248)         |
|                      | add_97 (BB.v:97)                                    |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Unsigned | 1     |                                          |
| I2    | PI   | Unsigned | 1     |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| I4    | PI   | Unsigned | 1     |                                          |
| I5    | PI   | Unsigned | 1     |                                          |
| I6    | PI   | Unsigned | 3     |                                          |
| I7    | PI   | Unsigned | 1     |                                          |
| I8    | PI   | Unsigned | 4     |                                          |
| T22   | IFO  | Unsigned | 2     | I1 + I2 ( BB.v:253 BB.v:260 BB.v:261 BB.v:263 BB.v:264 ) |
| T91   | IFO  | Unsigned | 3     | I3 + T22 ( BB.v:260 BB.v:263 BB.v:264 )  |
| T104  | IFO  | Unsigned | 3     | { I4, I5, I7 } ? T91 : T22 : I6 ( BB.v:248 BB.v:253 BB.v:260 ) |
| O1    | PO   | Unsigned | 3     | $unsigned(1'b1) + T91 (BB.v:264)         |
| O2    | PO   | Unsigned | 4     | I8 + T104 (BB.v:97)                      |
==============================================================================


Datapath Extraction Report

Information: Operator associated with resources 'cal01/add_264 (BB.v:264) cal01/add_264_2 (BB.v:264) cal01/add_264_3 (BB.v:264)' in design 'BB' breaks the datapath extraction because there is leakage due to truncation on its fanout.  (HDL-120)

Information: Operator associated with resources 'add_97 (BB.v:97)' in design 'BB' breaks the datapath extraction because there is leakage due to truncation on its fanout to operator of resources 'C222 (BB.v:104)'.  (HDL-120)

Information: Operator associated with resources 'cal01/add_307 (BB.v:307) cal01/add_307_2 (BB.v:307)' in design 'BB' breaks the datapath extraction because there is leakage due to truncation on its fanout to operator of resources 'cal01/C273 (BB.v:305)'.  (HDL-120)


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| gt_x_12            | DW_cmp           | apparch (area)     |                |
| gt_x_16            | DW_cmp           | apparch (area)     |                |
| lt_x_17            | DW_cmp           | apparch (area)     |                |
| gt_x_33            | DW_cmp           | apparch (area)     |                |
| add_x_34           | DW01_add         | apparch (area)     |                |
| add_x_30           | DW01_inc         | apparch (area)     |                |
| DP_OP_106J1_122_486                   |                    |                |
|                    | DP_OP_106J1_122_486 | str (area)      |                |
===============================================================================

1
