inputdir := justfile_directory() / "content"
outputdir := justfile_directory() / "output"
conffile := justfile_directory() / "pelicanconf.py"
publishconf := justfile_directory() / "publishconf.py"
s3_bucket := "data.onebiglibrary.net"

# show available recipes
default:
    @just --list

# (re)generate the web site
html *opts:
    pelican {{ inputdir }} -o {{ outputdir }} -s {{ conffile }} {{ opts }}

# remove the generated files
clean:
    rm -rf {{ outputdir }}

# regenerate files upon modification
regenerate *opts:
    pelican -r {{ inputdir }} -o {{ outputdir }} -s {{ conffile }} {{ opts }}

# serve site at http://localhost:PORT
serve port="8000" *opts:
    pelican -l {{ inputdir }} -o {{ outputdir }} -s {{ conffile }} -p {{ port }} {{ opts }}

# serve with auto-reload at http://localhost:PORT
devserver port="8000" *opts:
    pelican -lr {{ inputdir }} -o {{ outputdir }} -s {{ conffile }} -p {{ port }} {{ opts }}

# generate using production settings
publish *opts:
    pelican {{ inputdir }} -o {{ outputdir }} -s {{ publishconf }} {{ opts }}

# publish then upload to S3
s3_upload: publish
    s3cmd sync {{ outputdir }}/ s3://{{ s3_bucket }} --acl-public --delete-removed --guess-mime-type
