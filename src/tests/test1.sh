#!/bin/sh

rm -f out_test1_*

#BINDIR="valgrind -q .."
BINDIR=..

$BINDIR/gdal_trace_outline testcase_1.tif -ndv 255 -out-cs xy -wkt-out out_test1_1.wkt    -report out_test1_1.ppm -split-polys -dp-toler 0
$BINDIR/gdal_trace_outline testcase_1.tif -ndv 255 -out-cs en -wkt-out out_test1_1_en.wkt -dp-toler 0
$BINDIR/gdal_trace_outline testcase_2.tif -ndv 255 -out-cs xy -wkt-out out_test1_2.wkt    -report out_test1_2.ppm -split-polys -dp-toler 0
$BINDIR/gdal_trace_outline testcase_3.tif -ndv 255 -out-cs xy -wkt-out out_test1_3.wkt    -report out_test1_3.ppm -split-polys -dp-toler 0
$BINDIR/gdal_trace_outline testcase_4.png -ndv '0..255 0..255 0..255 0' -out-cs xy -wkt-out out_test1_4.wkt    -report out_test1_4.ppm -split-polys -dp-toler 0
$BINDIR/gdal_trace_outline testcase_5.png -ndv 255 -out-cs xy -wkt-out out_test1_5.wkt    -report out_test1_5.ppm -split-polys -dp-toler 0
$BINDIR/gdal_trace_outline testcase_maze.png  -ndv 255 -out-cs xy -wkt-out out_test1_maze.wkt  -report out_test1_maze.ppm  -split-polys -dp-toler 0
$BINDIR/gdal_trace_outline testcase_noise.png -b 1 -ndv   0 -out-cs xy -wkt-out out_test1_noise.wkt -report out_test1_noise.ppm -split-polys -dp-toler 0
$BINDIR/gdal_trace_outline testcase_noise.png -b 1 -ndv   0 -out-cs xy -wkt-out out_test1_noise_dp3.wkt -report out_test1_noise_dp3.ppm -split-polys -dp-toler 3

$BINDIR/gdal_trace_outline testcase_3.tif -out-cs xy -wkt-out out_test1_3_classify.wkt -dp-toler 0 -classify
$BINDIR/gdal_trace_outline pal.tif -out-cs xy -wkt-out out_test1_3_classify_pal.wkt -dp-toler 0 -classify

$BINDIR/gdal_list_corners -inspect-rect4 -erosion -ndv 0 testcase_4.png -report out_test1_4-rect.ppm > out_test1_4-rect.wkt

$BINDIR/gdal_wkt_to_mask -wkt good_test1_1_en.wkt -geo-from testcase_1.tif -mask-out out_test1_1_mask.ppm

$BINDIR/gdal_get_projected_bounds -s_wkt good_test1_1_en.wkt -s_srs '+proj=utm +zone=6 +ellps=WGS84 +units=m +no_defs ' -t_srs '+proj=stere +lat_ts=80 +lat_0=90 +lon_0=0 +ellps=WGS84' -report out_test1_projbounds_report.ppm > out_test1_projbounds.yml

$BINDIR/gdal_list_corners testcase_1.tif > out_test1_1_metdata.yml

$BINDIR/gdal_make_ndv_mask -ndv '155 52 52' -ndv '24 173 79'     testcase_3.tif out_test1_3_ndvmask.pbm
$BINDIR/gdal_make_ndv_mask -ndv '155 52 52' -ndv '24 173 79..81' testcase_3.tif out_test1_3_ndvmask2.pbm

echo '####################'

for i in good_test1_* ; do
	if diff --brief $i ${i/good/out} ; then
		echo "GOOD ${i/good_/}"
	else
		echo "BAD ${i/good_/}"
	fi
done
