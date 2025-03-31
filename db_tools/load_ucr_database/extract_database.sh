#!/bin/bash


# Default dbname
dbname="ucr_prd"
schema=NULL
schema_parameter=""
# Parse command-line arguments for dbname
while getopts d: flag
do
    case "${flag}" in
        d) dbname=${OPTARG};;
    esac
done

# Parse command-line arguments for schema
while getopts s: flag
do
    case "${flag}" in
        s) 
            schema=${OPTARG}
            schema_parameter="--schema=${schema}"
            ;;
    esac
done

# Get the current date
year=$(date +%Y)
month=$(date +%m)
day=$(date +%d)

file_prefix="${dbname}_${year}_${month}_${day}"
echo $file_prefix



# extract the pre-data
pg_dump --create $schema_parameter --no-owner --no-acl --no-privileges --format=plain  --section=pre-data  --file="${file_prefix}-pre.sql"  $dbname
 

# extract the raw data in compressed form
pg_dump $schema_parameter --no-owner --no-acl --no-privileges --format=custom --section=data --compress=9 --file="${file_prefix}-data.dmp.gz" $dbname
 
# extract the post-data
pg_dump $schema_parameter --no-owner --no-acl --no-privileges --format=plain --section=post-data --file="${file_prefix}-post.sql" $dbname
echo "Please remove the create database command from the post-data file"
echo Linux, please run: sed -i '/CREATE DATABASE/d' "${file_prefix}-post.sql"
echo "Mac, please run: sed -i '' '/CREATE DATABASE/d' \"${file_prefix}-post.sql\" "