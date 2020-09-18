#!/bin/bash

#source read_ini.sh

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
	local encode_type=`uchardet $filepath`

	iconv --list | grep $encode_type > /dev/null
    if [ $? != 0 ]; then
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

	iconv -f $encode_type -t utf-8 -o $destiny $origin
	if [ $? != 0 ]; then
		exit 1
	fi
	echo $destiny
}


filename_from_ftp[0]="../temp/dc.lista-productos"
filename_from_ftp[1]="../temp/ct.lista-productos"
destiny_folder='../private'
declare -A ftp_host
ftp_host[1]['name']="ftp://fulloffice.com.mx"
file_uri="Lista%20de%20Precios%20101444.csv"
host_user='fulloffice';
host_password='Fulloffice2020!'

ftp_source ${filename_from_ftp[0]};
if [ $? == 1 ]; then
	echo "ERROR: $? al obtener de ftp: no se pudo crear el archivo $loca_file"
	exit 1
fi
echo "Se obtuvó el archivo ${filename_from_ftp[0]}"

encode_type=`encodetype ${filename_from_ftp[0]}` 
if [ $? == 1 ]; then
	echo "ERROR: Códificación de archivo no soportada $encode_type"
	exit 2
fi
echo "La codificación del archivo es $encode_type"

filename=`convert_utf8 $encode_type ${filename_from_ftp[0]} $destiny_folder`
if [ $? == 1 ]; then
	echo "ERROR $?: no se pudo crear el archivo utf8"
	exit 3 
fi
echo "Se generó el archivo $filename"
