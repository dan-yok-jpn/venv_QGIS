PACKAGE=package_1

build:
	python setup.py sdist bdist_wheel

install:
	python -m pip install dist/$(PACKAGE)-*.whl

uninstall:
	python -m pip uninstall $(PACKAGE)

clean:
	rm -rf build dist $(PACKAGE).egg-info

