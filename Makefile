# This should best be read from setup.{py,cfg}
VERSION=0.3.3

default:
	@echo "\"make publish\"?"

# https://packaging.python.org/distributing/#id72
upload: clean
	# Make sure we're on the master branch
	@if [ "$(shell git rev-parse --abbrev-ref HEAD)" != "master" ]; then exit 1; fi
	rm -rf dist/*
	python3 setup.py sdist
	twine upload dist/*.tar.gz

tag:
	@if [ "$(shell git rev-parse --abbrev-ref HEAD)" != "master" ]; then exit 1; fi
	# @echo "Tagging v$(VERSION)..."
	# git tag v$(VERSION)
	# git push --tags
	curl -H "Authorization: token `cat $(HOME)/.github-access-token`" -d '{"tag_name": "v$(VERSION)"}' https://api.github.com/repos/nschloe/accupy/releases

publish: tag upload

clean:
	@find . | grep -E "(__pycache__|\.pyc|\.pyo$\)" | xargs rm -rf
	@rm -rf *.egg-info/ build/ dist/ MANIFEST

format:
	isort .
	black .

black:
	black .

lint:
	black --check .
	flake8 .
