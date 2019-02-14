Readme
======

This project allows an administrator to override translation at the LMS and STUDIO for NAU.

It supports server side and browser side rendered strings.

Translations overridden by this project will have an effect on the edx-platform core project, the nau-basic theme and external packages such as ORA2.


Getting started on Devstack
===========================

Get the code on your devstack go to the directory where you cloned the devstack repository.

Get the code:
```
mkdir -p src/edxapp
cd src/edxapp
git clone git@gitlab.fccn.pt:nau/nau_translations.git
```

Install the requirements:
```
cd nau_translations
virtualenv venv
source venv/bin/activate
make requirements
```

Activate the COMPREHENSIVE_THEME_LOCALE_PATHS:

Both on the LMS and STUDIO you need to edit the file `/edx/app/edxapp/lms.env.json` and modify the COMPREHENSIVE_THEME_LOCALE_PATHS. For studio, the modification also needs to be done at the `lms.env.json` since studio will inherit this particular setting from the LMS.

Normally it looks like:
```
"COMPREHENSIVE_THEME_LOCALE_PATHS": [
    "/edx/var/edx-themes/edx-themes/edx-platform/nau-basic/conf/locale",
],
```

Make it:
```
"COMPREHENSIVE_THEME_LOCALE_PATHS": [
    "/edx/var/edx-themes/edx-themes/edx-platform/nau-basic/conf/locale",
    "/edx/src/edxapp/nau_translations/conf/locale"
],
```
Note: the nau_translations locale must be the last in this list, so that upon initialization it gets loaded into the overall first position of the LOCALE_PATHS.

You can edit the file using the containers using:
```
# lms
make lms-shell
vi ../lms.env.json

# studio
make studio-shell
vi ../lms.env.json
```

Now you are ready to run the code:
```
make compile_translations
make publish_lms_devstack
make publish_studio_devstack
```


Getting started on a Native installation. E.g. DEV, STAGE, PROD
===============================================================
TBD

Running from Jenkins
====================
TBD


Developer notes
===============

- [] for cms it does not override the theme until we merge the common.py changes
- [] What happens if we modify COMPREHENSIVE_THEME_LOCALE_PATHS before we clone?

next steps
- [] add COMPREHENSIVE_THEME_LOCALE_PATHS over ansible
- [] clone repo using ansible on DEV (master)
- [] manually run the update until it works
- [] automate update
- [] add update to the regular deployments as a final step
- [] solve issue with modifications to the edx-platform repo
