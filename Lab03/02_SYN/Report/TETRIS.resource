 
****************************************
Report : resources
Design : TETRIS
Version: T-2022.03
Date   : Sun Sep 29 21:43:00 2024
****************************************


Resource Report for this hierarchy in file ../01_RTL/TETRIS.v
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_3        | DW01_inc       | width=4    | add_160_S2 (TETRIS.v:160)  |
| add_x_11       | DW01_add       | width=4    | add_282_2 (TETRIS.v:282)   |
| add_x_12       | DW01_inc       | width=4    | add_287 (TETRIS.v:287)     |
| add_x_13       | DW01_inc       | width=4    | add_300_2 (TETRIS.v:300)   |
| add_x_14       | DW01_inc       | width=4    | add_305 (TETRIS.v:305)     |
| add_x_15       | DW01_inc       | width=4    | add_306_2 (TETRIS.v:306)   |
| gt_x_16        | DW_cmp         | width=4    | gt_361 (TETRIS.v:361)      |
| gt_x_17        | DW_cmp         | width=4    | gt_362 (TETRIS.v:362)      |
| gt_x_18        | DW_cmp         | width=4    | gt_363 (TETRIS.v:363)      |
| add_x_42       | DW01_add       | width=5    | add_382 (TETRIS.v:382)     |
| add_x_44       | DW01_add       | width=4    | add_388 (TETRIS.v:388)     |
| sub_x_46       | DW01_sub       | width=5    | sub_394 (TETRIS.v:394)     |
| add_x_2737     | DW01_inc       | width=3    | add_614 (TETRIS.v:614)     |
| add_x_39       | DW01_inc       | width=4    | add_374 (TETRIS.v:374)     |
|                |                |            | add_386 (TETRIS.v:386)     |
|                |                |            | add_392 (TETRIS.v:392)     |
|                |                |            | add_399 (TETRIS.v:399)     |
|                |                |            | add_404 (TETRIS.v:404)     |
|                |                |            | add_411 (TETRIS.v:411)     |
|                |                |            | add_416 (TETRIS.v:416)     |
| add_x_40       | DW01_inc       | width=5    | add_375 (TETRIS.v:375)     |
|                |                |            | add_376 (TETRIS.v:376)     |
|                |                |            | add_380 (TETRIS.v:380)     |
|                |                |            | add_405 (TETRIS.v:405)     |
|                |                |            | add_410 (TETRIS.v:410)     |
| sub_x_45       | DW01_dec       | width=5    | sub_393 (TETRIS.v:393)     |
|                |                |            | sub_397 (TETRIS.v:397)     |
|                |                |            | sub_412 (TETRIS.v:412)     |
|                |                |            | sub_415 (TETRIS.v:415)     |
|                |                |            | sub_416 (TETRIS.v:416)     |
| add_x_43       | DW01_add       | width=4    | add_387 (TETRIS.v:387)     |
|                |                |            | add_400 (TETRIS.v:400)     |
|                |                |            | add_418 (TETRIS.v:418)     |
| add_x_41       | DW01_add       | width=5    | add_381 (TETRIS.v:381)     |
|                |                |            | add_406 (TETRIS.v:406)     |
=============================================================================


Datapath Extraction Report

Information: Operator associated with resources 'add_287 (TETRIS.v:287)' in design 'TETRIS' breaks the datapath extraction because there is leakage due to truncation on its fanout to operator of resources 'C11966 (TETRIS.v:262)'.  (HDL-120)

Information: Operator associated with resources 'add_305 (TETRIS.v:305)' in design 'TETRIS' breaks the datapath extraction because there is leakage due to truncation on its fanout to operator of resources 'C11966 (TETRIS.v:262)'.  (HDL-120)

Information: Operator associated with resources 'add_282_2 (TETRIS.v:282)' in design 'TETRIS' breaks the datapath extraction because there is leakage due to truncation on its fanout to operator of resources 'C11967 (TETRIS.v:262)'.  (HDL-120)

Information: Operator associated with resources 'add_300_2 (TETRIS.v:300)' in design 'TETRIS' breaks the datapath extraction because there is leakage due to truncation on its fanout to operator of resources 'C11967 (TETRIS.v:262)'.  (HDL-120)

Information: Operator associated with resources 'add_306_2 (TETRIS.v:306)' in design 'TETRIS' breaks the datapath extraction because there is leakage due to truncation on its fanout to operator of resources 'C11967 (TETRIS.v:262)'.  (HDL-120)


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_x_3            | DW01_inc         | apparch (area)     |                |
| add_x_11           | DW01_add         | apparch (area)     |                |
| add_x_12           | DW01_inc         | apparch (area)     |                |
| add_x_13           | DW01_inc         | apparch (area)     |                |
| add_x_14           | DW01_inc         | apparch (area)     |                |
| add_x_15           | DW01_inc         | apparch (area)     |                |
| gt_x_16            | DW_cmp           | apparch (area)     |                |
| gt_x_17            | DW_cmp           | apparch (area)     |                |
| gt_x_18            | DW_cmp           | apparch (area)     |                |
| add_x_42           | DW01_add         | apparch (area)     |                |
| add_x_44           | DW01_add         | apparch (area)     |                |
| sub_x_46           | DW01_sub         | apparch (area)     |                |
| add_x_2737         | DW01_inc         | apparch (area)     |                |
| add_x_39           | DW01_inc         | apparch (area)     |                |
| add_x_40           | DW01_inc         | apparch (area)     |                |
| sub_x_45           | DW01_dec         | apparch (area)     |                |
| add_x_43           | DW01_add         | apparch (area)     |                |
| add_x_41           | DW01_add         | apparch (area)     |                |
===============================================================================

1
