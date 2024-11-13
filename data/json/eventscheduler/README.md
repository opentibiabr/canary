# Events Scheduler Configuration - README

This README provides instructions on how to configure and use the `events.json` file for scheduling events in the Otservbr server environment.

## Overview

The `events.json` file allows you to schedule various in-game events, defining their properties such as start and end dates, experience rate, loot rate, and more. This allows you to create custom in-game experiences at specific times.

The file contains an array of events, with each event having various attributes that control the properties of the event.

## JSON Structure

Here is a breakdown of the `events.json` structure:

```json
{
	"events": [
		{
			"name": "Otservbr example 1",
			"startdate": "11/03/2020",
			"enddate": "12/30/2025",
			"script": "example.lua",
			"ingame": {
				"exprate": 100,
				"lootrate": 100,
				"bosslootrate": 100,
				"spawnrate": 100,
				"skillrate": 100
			},
			"description": "Otserver br example 1 description double exp and a half, double loot !chance!, regular spawn and double skill",
			"colors": {
				"colordark": "#235c00",
				"colorlight": "#2d7400"
			},
			"details": {
				"displaypriority": 6,
				"isseasonal": 0,
				"specialevent": 0
			}
		},
		{
			"name": "Otservbr example 2",
			"startdate": "2/2/2022",
			"enddate": "12/31/2025",
			"script": "",
			"ingame": {
				"exprate": 100,
				"lootrate": 100,
				"bosslootrate": 100,
				"spawnrate": 100,
				"skillrate": 100
			},
			"description": "Otserver br example 2 description 50% less exp, triple loot !chance!, 50% faster spawn and regular skill",
			"colors": {
				"colordark": "#735D10",
				"colorlight": "#8B6D05"
			},
			"details": {
				"displaypriority": 6,
				"isseasonal": 0,
				"specialevent": 0
			}
		}
	]
}
```

## Attributes Explained

### Event Attributes

- **name**: The name of the event.
- **startdate**: The start date of the event in the format `mm/dd/yyyy`.
- **enddate**: The end date of the event in the format `mm/dd/yyyy`.
- **script**: The script to be executed during the event (optional).

### In-game Attributes (`ingame`)

- **exprate**: The experience rate during the event.
- **lootrate**: The loot rate during the event.
- **bosslootrate**: The boss loot rate during the event.
- **spawnrate**: The spawn rate of monsters during the event.
- **skillrate**: The skill rate during the event.

### Description

- **description**: A textual description of the event, explaining its features.

### Colors (`colors`)

- **colordark**: The dark color associated with the event (in hexadecimal).
- **colorlight**: The light color associated with the event (in hexadecimal).

### Event Details (`details`)

- **displaypriority**: The priority level for displaying the event.
- **isseasonal**: Indicates whether the event is seasonal (`0` for no, `1` for yes).
- **specialevent**: Indicates whether the event is considered a special event (`0` for no, `1` for yes).

## How to Add a New Event

To add a new event:
1. Open the `events.json` file.
2. Add a new object to the `events` array with the appropriate details. Make sure to follow the structure outlined above.
3. Ensure that the `startdate` and `enddate` are in the correct format (`mm/dd/yyyy`), and adjust the in-game rates and other properties as needed.

### Example
Here is an example of a new event you could add:

```json
{
	"name": "Double XP Weekend",
	"startdate": "01/01/2026",
	"enddate": "01/03/2026",
	"script": "double_xp.lua",
	"ingame": {
		"exprate": 200,
		"lootrate": 100,
		"bosslootrate": 150,
		"spawnrate": 120,
		"skillrate": 150
	},
	"description": "Enjoy a double XP weekend with increased boss loot and spawn rates!",
	"colors": {
		"colordark": "#1a2b3c",
		"colorlight": "#3c4d5e"
	},
	"details": {
		"displaypriority": 5,
		"isseasonal": 0,
		"specialevent": 1
	}
}
```

## Notes
- Make sure the JSON file is well-formed. You can use an online JSON validator to check for syntax errors.
- Always back up your `events.json` file before making major changes.

## Troubleshooting
- **JSON Parsing Errors**: If you encounter JSON parsing errors, check for missing commas or incorrect formatting in your file.
- **Missing Event Details**: Ensure all required attributes are properly defined for each event.

## Contact
For additional help, contact the support team or refer to the project's documentation.

