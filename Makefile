README.md: *.tf README.header
	terraform-docs markdown . > terraform.md
	cat README.header terraform.md > README.md
	rm terraform.md
