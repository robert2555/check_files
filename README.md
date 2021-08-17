# check_files.sh
This is a simple file checker to monitor files in a unix directory. I use it with Nagios. 

## Usage
```
check_files.sh <folder> <warning> <critical> <period> <opt:file> <opt:depth>
```
Examples: 
```
check_files.sh /tmp 30 60 minutes .txt
check_files.sh /tmp 1 3 days
```
           
