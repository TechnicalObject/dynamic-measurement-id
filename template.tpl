___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Dynamic Measurement ID",
  "description": "",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "CHECKBOX",
    "name": "devOverride",
    "checkboxText": "Bypass DEV property ID while testing",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "prodMeasurementId",
    "displayName": "PROD Measurement ID",
    "simpleValueType": true,
    "valueHint": "G-XXXXXXXXXX",
    "valueValidators": [
      {
        "type": "REGEX",
        "args": [
          "^G-[A-Z0-9]{10}$"
        ],
        "errorMessage": "Measurement ID must be in the form G-XXXXXXXXXX"
      },
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "devMeasurementId",
    "displayName": "(Optional) DEV Measurement ID",
    "simpleValueType": true,
    "valueHint": "G-XXXXXXXXXX",
    "valueValidators": [
      {
        "type": "REGEX",
        "args": [
          "^G-[A-Z0-9]{10}$"
        ],
        "errorMessage": "Measurement ID must be in the form G-XXXXXXXXXX"
      }
    ],
    "notSetText": "Not Set"
  },
  {
    "type": "RADIO",
    "name": "selectionType",
    "displayName": "Manual list of domains or RegExp",
    "radioItems": [
      {
        "value": "list",
        "displayValue": "List manually"
      },
      {
        "value": "regex",
        "displayValue": "Regex"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "list",
    "enablingConditions": [
      {
        "paramName": "devMeasurementId",
        "paramValue": "",
        "type": "PRESENT"
      }
    ]
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "stgHostnames",
    "displayName": "Staging Hostnames",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "",
        "name": "hostname",
        "type": "TEXT",
        "valueValidators": [
          {
            "type": "REGEX",
            "args": [
              "^([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\\.){1,}([a-zA-Z]{2,6})$"
            ]
          }
        ]
      }
    ],
    "enablingConditions": [
      {
        "paramName": "selectionType",
        "paramValue": "list",
        "type": "EQUALS"
      }
    ],
    "valueValidators": [
      {
        "type": "NON_EMPTY",
        "errorMessage": "Please enter at least one hostname"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "regex",
    "displayName": "RegEx value",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "selectionType",
        "paramValue": "regex",
        "type": "EQUALS"
      }
    ],
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Enter your template code here.
const getUrl = require('getUrl');
const getContainerVersion = require('getContainerVersion');
const log = require('logToConsole'); 

const measurementId = data.prodMeasurementId;
const devMeasurementId = data.devMeasurementId;
const hostname = getUrl('host');
const cv = getContainerVersion();
let isDev = false;
const hostnameObj = data.stgHostnames;
log('selection type =', data.selectionType);
if (data.selectionType === 'list' && hostnameObj) {
  const stgHostnames = data.stgHostnames.map(item => item.hostname);
  log('stgHostnames =', stgHostnames);
  isDev = stgHostnames.indexOf(hostname) === -1 ? false : true;
} else if (data.selectionType === 'regex') {
  isDev = hostname.match(data.regex);
}

if ((cv.debugMode || isDev) && devMeasurementId && !data.devOverride) {
  return devMeasurementId;
}

// Variables must return a value.
return measurementId;


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_container_data",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_url",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "host",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
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
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: PROD
  code: |-
    mock('getUrl', 'example.com');
    mock('getContainerVersion', containerVersion);

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);
    assertApi('getUrl').wasCalled();
    assertApi('getContainerVersion').wasCalled();

    // Verify that the variable returns a result.
    assertThat(variableResult).isEqualTo('G-456PROD');
- name: PROD preview
  code: |-
    containerVersion.debugMode = true;
    mock('getUrl', 'example.com');
    mock('getContainerVersion', containerVersion);

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);
    assertApi('getUrl').wasCalled();
    assertApi('getContainerVersion').wasCalled();

    // Verify that the variable returns a result.
    assertThat(variableResult).isEqualTo('G-123DEV');
- name: DEV
  code: |-
    mock('getUrl', 'web-stg.example.com');
    mock('getContainerVersion', containerVersion);

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);
    assertApi('getUrl').wasCalled();
    assertApi('getContainerVersion').wasCalled();

    // Verify that the variable returns a result.
    assertThat(variableResult).isEqualTo('G-123DEV');
- name: DEV preview
  code: |-
    containerVersion.debugMode = true;
    mock('getUrl', 'web-stg.example.com');
    mock('getContainerVersion', containerVersion);

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);
    assertApi('getUrl').wasCalled();
    assertApi('getContainerVersion').wasCalled();

    // Verify that the variable returns a result.
    assertThat(variableResult).isEqualTo('G-123DEV');
- name: RegExp PROD
  code: |-
    mockData.selectionType = 'regex';
    mock('getUrl', 'example.com');
    mock('getContainerVersion', containerVersion);

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);
    assertApi('getUrl').wasCalled();
    assertApi('getContainerVersion').wasCalled();

    // Verify that the variable returns a result.
    assertThat(variableResult).isEqualTo('G-456PROD');
- name: RegExp test DEV
  code: |-
    mockData.selectionType = 'regex';
    mock('getUrl', 'web-stg.example.com');
    mock('getContainerVersion', containerVersion);

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);
    assertApi('getUrl').wasCalled();
    assertApi('getContainerVersion').wasCalled();

    // Verify that the variable returns a result.
    assertThat(variableResult).isEqualTo('G-123DEV');
setup: |-
  const mockData = {
    prodMeasurementId: 'G-456PROD',
    devMeasurementId: 'G-123DEV',
    stgHostnames: [{"hostname":"web-dev.example.com"}, {"hostname":"web-stg.example.com"}],
    selectionType: 'list',
    regex: '-stg|local',
    devOverride: false
  };

  const containerVersion = {
    "containerId":"GTM-P6DJ24X",
    "version":"1",
    "environmentName":"",
    "debugMode":false,
    "previewMode":true,
    "environmentMode":false,
    "firstPartyServing":false,
    "containerUrl":""
  };


___NOTES___

Created on 20/02/2025, 17:44:41


