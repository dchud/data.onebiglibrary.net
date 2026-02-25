set dotenv-load

inputdir := justfile_directory() / "content"
outputdir := justfile_directory() / "output"
conffile := justfile_directory() / "pelicanconf.py"
publishconf := justfile_directory() / "publishconf.py"
amplify_app_id := env("AMPLIFY_APP_ID", "")
amplify_branch := "main"

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

# publish then deploy to Amplify
deploy: publish
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -z "{{ amplify_app_id }}" ]; then
        echo "Error: set AMPLIFY_APP_ID in your environment" >&2
        exit 1
    fi
    echo "Zipping output..."
    cd "{{ outputdir }}" && zip -qr ../site.zip .
    cd "{{ justfile_directory() }}"
    echo "Creating deployment..."
    response=$(aws amplify create-deployment \
        --app-id "{{ amplify_app_id }}" \
        --branch-name "{{ amplify_branch }}")
    upload_url=$(echo "$response" | jq -r '.zipUploadUrl')
    job_id=$(echo "$response" | jq -r '.jobId')
    echo "Uploading site.zip..."
    curl -sf -T site.zip "$upload_url"
    echo "Starting deployment (job $job_id)..."
    aws amplify start-deployment \
        --app-id "{{ amplify_app_id }}" \
        --branch-name "{{ amplify_branch }}" \
        --job-id "$job_id" > /dev/null
    rm site.zip
    echo "Deployed! Check status at:"
    echo "  https://console.aws.amazon.com/amplify/apps/{{ amplify_app_id }}"

# open Goatcounter analytics dashboard
stats:
    open https://data-obl-net.goatcounter.com/

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
