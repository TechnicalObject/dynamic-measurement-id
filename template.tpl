___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Set Cookie",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "by Luboš Komjati",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "cookieType",
    "displayName": "Cookie Type",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "internal",
        "displayValue": "Internal"
      },
      {
        "value": "custom",
        "displayValue": "Custom"
      }
    ],
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "cookieName",
    "displayName": "Cookie Name",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "cookieType",
        "paramValue": "internal",
        "type": "NOT_EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "cookieValue",
    "displayName": "Cookie Value",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "cookieType",
        "paramValue": "internal",
        "type": "NOT_EQUALS"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "maxAgeCheckbox",
    "checkboxText": "Specify Max Age",
    "simpleValueType": true,
    "help": "Specify maximum age of the cookie in days.",
    "enablingConditions": [
      {
        "paramName": "cookieType",
        "paramValue": "internal",
        "type": "NOT_EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "maxAge",
    "displayName": "Max-Age",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "maxAgeCheckbox",
        "paramValue": true,
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Enter your template code here.
const log = require('logToConsole');
const setCookie = require('setCookie');

log('data =', data);

const options = {
  'domain' : 'auto'
};

if (data.maxAge) {
  options['max-age'] = data.maxAge * 24 * 60 * 60 * 1000;
}

if (data.cookieType === 'internal') {
  data.cookieName = 'gtm_internal_user';
  data.cookieValue = 'internal';
}

setCookie(data.cookieName, data.cookieValue, options);

// Call data.gtmOnSuccess when the tag is finished.
data.gtmOnSuccess();


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "set_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedCookies",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "name"
                  },
                  {
                    "type": 1,
                    "string": "domain"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "session"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Test
  code: |-
    const log = require('logToConsole');
    const mockData = {
      "maxAge":"365",
      "cookieValue":"true",
      "cookieName":"test"
    };

    // Call runCode to run the template's code.
    runCode(mockData);

    // Verify that the tag finished successfully.
    assertApi('gtmOnSuccess').wasCalled();


___NOTES___

Created on 25/12/2024, 23:19:27


