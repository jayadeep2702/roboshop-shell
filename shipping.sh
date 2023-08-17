script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_passwd=$1

if [ -z "$mysql_root_passwd" ]; then
echo mysql password is missing
exit
fi
component="shipping"
func_schema_setup="mysql"
func_java