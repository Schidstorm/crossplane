all: install build deploy _cleanup_build

template:
	mkdir -p templates && \
	find . -name "Chart.yaml" | sort -V | xargs -I {} sh -c 'dir=$$(dirname "{}"); helm template $${dir##*/} "$$dir" > templates/$${dir##*/}-template.yaml'

install:
	find . -name "Chart.yaml" | sort -V | \
		xargs -I {} sh -c 'dir=$$(dirname "{}"); \
			helm dependency update "$$dir"'

build:
	find . -name "Chart.yaml" | sort -V | \
		xargs -I {} sh -c 'dir=$$(dirname "{}"); \
			helm package "$$dir" -d .'

deploy:
	find . -name "Chart.yaml" | sort -V | \
		xargs -I {} sh -c 'set -e; \
			dir=$$(dirname "{}"); \
			dirname=$${dir##*/}; \
			chartname=$${dirname#[0-9][0-9]-}; \
			echo "Deploying $$chartname..."; \
			helm upgrade --install $$chartname "./$$chartname-0.1.0.tgz" \
				--namespace $$chartname --create-namespace'

_cleanup_build:
	rm -f *.tgz 

clean:
	find . -name "Chart.yaml" | sort -r -V | \
		xargs -I {} sh -c 'dir=$$(dirname "{}"); \
			dirname=$${dir##*/}; \
			chartname=$${dirname#[0-9][0-9]-}; \
			helm uninstall $$chartname --namespace $$chartname' || true && \
	rm -rf templates
	