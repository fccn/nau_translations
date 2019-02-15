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

Both on the LMS and STUDIO you need to edit the file `/edx/app/edxapp/lms.env.json` and modify the COMPREHENSIVE_THEME_LOCALE_PATHS. For studio, the modification also needs to be done both at the `cms.env.json` since studio will inherit this particular setting from the LMS during a part of the procedure.

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
vi ../cms.env.json
```

Now you are ready to run the code:
```
make compile_translations
make publish_lms_devstack
make publish_studio_devstack
```


Getting started on a Native installation. E.g. DEV, STAGE, PROD
===============================================================


Get the code:
```
sudo mkdir -p /edx/var/i18n_nau
cd /edx/var/i18n_nau
sudo git clone git@gitlab.fccn.pt:nau/nau_translations.git
sudo chown edxapp:www-data -R /edx/var/i18n_nau
```

Activate the COMPREHENSIVE_THEME_LOCALE_PATHS:

Edit the files `/edx/app/edxapp/lms.env.json` and `/edx/app/edxapp/cms.env.json`. In them modify the COMPREHENSIVE_THEME_LOCALE_PATHS.

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
    "/edx/var/i18n_nau/nau_translations/conf/locale"
],
```

Now you are ready to run the code:
```
/edx/var/i18n_nau/nau_translations/bin/publish_native
```

Running from Jenkins
====================

Currently this project is installed only at the DEV environment (https://lms.dev.nau.fccn.pt/)

There is an both an ansible playbook and a jenkins task to run said playbook.

The jenkins task can be found at https://jenkins.static.dev.nau.fccn.pt/view/i18n/job/Apply-nau-translations-final-layer/
To run the default parameters are already correct.


Developer notes
===============

next steps
- [] add update to the regular deployments as a final step

