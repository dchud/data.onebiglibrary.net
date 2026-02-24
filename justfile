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
    uv run pelican {{ inputdir }} -o {{ outputdir }} -s {{ conffile }} {{ opts }}

# remove the generated files
clean:
    rm -rf {{ outputdir }}

# regenerate files upon modification
regenerate *opts:
    uv run pelican -r {{ inputdir }} -o {{ outputdir }} -s {{ conffile }} {{ opts }}

# serve site at http://localhost:PORT
serve port="8000" *opts:
    uv run pelican -l {{ inputdir }} -o {{ outputdir }} -s {{ conffile }} -p {{ port }} {{ opts }}

# serve with auto-reload at http://localhost:PORT
devserver port="8000" *opts:
    uv run pelican -lr {{ inputdir }} -o {{ outputdir }} -s {{ conffile }} -p {{ port }} {{ opts }}

# generate using production settings
publish *opts:
    uv run pelican {{ inputdir }} -o {{ outputdir }} -s {{ publishconf }} {{ opts }}

# publish then upload to S3
s3_upload: publish
    s3cmd sync {{ outputdir }}/ s3://{{ s3_bucket }} --acl-public --delete-removed --guess-mime-type

# scaffold a new post: just new My Cool Post
new +title:
    #!/usr/bin/env bash
    set -euo pipefail
    date=$(date +%Y%m%d)
    slug=$(echo "{{ title }}" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | tr -s '-' | sed 's/^-//;s/-$//')
    dir="{{ inputdir }}/posts/${date}-${slug}"
    if [ -d "$dir" ]; then
        echo "Error: $dir already exists" >&2
        exit 1
    fi
    mkdir -p "$dir"
    cat > "$dir/index.md" << 'TEMPLATE'
    Title:      {{ title }}
    Summary:
    Tags:
    Status:     draft

    Write your post here.

    <!-- Examples (delete when done):

    Image:
    ![alt text]({attach}image.png)

    YouTube:
    <iframe width="560" height="315"
      src="https://www.youtube.com/embed/VIDEO_ID"
      frameborder="0" allowfullscreen></iframe>
    -->
    TEMPLATE
    echo "Created $dir/index.md"
