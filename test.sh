#!/bin/bash

source read_ini.sh

temp_file[0]="../temp/ct.lista-productos"
temp_file[1]="../temp/dc.lista-productos"
destiny_folder='../private'

ftp_source() {
	local ftp_host="ftp://fulloffice.com.mx"
	local file_uri="Lista%20de%20Precios%20101444.csv"
	local host_user='fulloffice';
	local host_password='Fulloffice2020!'
	local local_file=$1;
	command="${ftp_host}/${file_uri} --user ${host_user}:${host_password}"
	output_file=`curl  $command > $local_file`
	echo $output_file

	#if[ $? != 0] 
		#echo "error $? al obtener de ftp: no se pudo crear el archivo $loca_file"
		#exit(1)
	#fi
	
}

encodetype() {
	local filepath=$1
	local encode_type=`file -bi $filepath  |cut -d " " -f 2 | cut -d "=" -f 2`
	iconv --list | grep "$encode_type"
    if [ $? != 0 ]
	 	then
		encode_type="ISO_8859-5" 
	fi
	echo $encode_type
}


convert_utf8() {
	local encode_type=$1
	local origin=$2
	local basename=`basename $origin`
	local destiny="$3/utf8.${basename}"
	`iconv -f $encode_type -t utf-8 -o $destiny $origin `
}




#`ftp_source ${temp_file[0]}`;
encode_type=`encodetype ${temp_file[0]}`
`convert_utf8 $encode_type ${temp_file[0]} $destiny_folder`


if [ $? != 0 ]; then
	echo "error $?: no se pudo crear el archivo utf8"
	#exit( 2 )
fi
	




