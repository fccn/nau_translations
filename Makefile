########################################################################################################################
#
#
########################################################################################################################
.DEFAULT_GOAL := help
.PHONY: requirements

# Generates a help message. Borrowed from https://github.com/pydanny/cookiecutter-djangopackage.
help: ## Display this help message
	@echo "Please use \`make <target>' where <target> is one of"
	@perl -nle'print $& if m{^[\.a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}'

requirements: ## Install pybabel, run it in a virtualenv
	pip install babel edx-i18n-tools==0.4.6

compile_translations: ## Compile .mo files into .po files
	pybabel compile -f -D django -d conf/locale/
	pybabel compile -f -D djangojs -d conf/locale/

publish_lms_devstack: | compile_translations
	@echo "Running compilejsi18n && collectstatic at lms"
	@docker exec -t edx.devstack.lms bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform/ && python manage.py lms compilejsi18n --locale pt-pt'
	@docker exec -t edx.devstack.lms bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform/ && python manage.py lms compilejsi18n --locale en'
	@docker exec -t edx.devstack.lms bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform/ && python manage.py lms collectstatic -i *css -i templates -i vendor --noinput -v2 | grep Copying | grep i18n'
	@docker exec -t edx.devstack.lms bash -c 'kill $$(ps aux | grep "manage.py lms" | egrep -v "while|grep" | awk "{print \$$2}")'

publish_studio_devstack: | compile_translations
	@echo "Running compilejsi18n && collectstatic at studio"
	@docker exec -t edx.devstack.studio bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform/ && python manage.py cms compilejsi18n --locale pt-pt'
	@docker exec -t edx.devstack.studio bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform/ && python manage.py cms compilejsi18n --locale en'
	@docker exec -t edx.devstack.studio bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform/ && python manage.py cms collectstatic -i *css -i templates -i vendor --noinput -v2 | grep Copying | grep i18n'
	@docker exec -t edx.devstack.studio bash -c 'kill $$(ps aux | grep "manage.py cms" | egrep -v "while|grep" | awk "{print \$$2}")'

publish_native:
	bin/publish_native

pull_translations:
	tx pull -f --minimum-perc=10 -l en -l pt-pt
	i18n_tool generate
	i18n_tool validate
