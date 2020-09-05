#!/bin/bash

source read_ini.sh


ftp_source() {
	local ftp_host="ftp://fulloffice.com.mx"
	local file_uri="Lista%20de%20Precios%20101444.csv"
	local host_user='fulloffice';
	local host_password='Fulloffice2020!'
	local local_file=$1;

	local destiny_folder=`dirname $local_file`
	mkdir $destiny_folder &> /dev/null

	curl_parameters="${ftp_host}/${file_uri} --user ${host_user}:${host_password}"
	output_file=`curl  $curl_parameters > $local_file`

	if [ $? != 0 ]; then
		exit 1
	fi
	
	echo $output_file
}

encodetype() {
	local filepath=$1
	local encode_type=`file -bi $filepath  |cut -d " " -f 2 | cut -d "=" -f 2`
	iconv --list | grep "$encode_type"
    if [ $? != 0 ]; then
		echo $2
		exit 1
	fi

 	echo $encode_type

}


convert_utf8() {
	local encode_type=$1
	local origin=$2
	local basename=`basename $origin`
	local destiny_folder=$3
	
	local destiny="${destiny_folder}/utf8.${basename}"

	iconv -f $encode_type -t utf-8 -o $destiny $origin &> /dev/null

	if [ $? != 0]; then
		exit 1
	fi

	echo "Se generó el archivo utf8 en $destiny"
}


temp_file[0]="../temp/ct.lista-productos"
temp_file[1]="../temp/dc.lista-productos"
destiny_folder='../private'
encode_default='ISO_8859-5'

ftp_source ${temp_file[0]};
if [ $? == 1 ]; then
	echo "error $? al obtener de ftp: no se pudo crear el archivo $loca_file"
	exit 1
fi

encode_type=`encodetype ${temp_file[0]} $encode_default` 
if [ $? == 1 ]; then
	echo "WARNING: El formato del archivo no es reconocido $file_encode  se usará $encode_default en su lugar"
	exit 2
fi

convert_utf8 $encode_type ${temp_file[0]} $destiny_folder
if [ $? == 1 ]; then
	echo "error $?: no se pudo crear el archivo utf8"
	exit 3 
fi
	




