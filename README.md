# VkParser

A quite fast scrapper of different stuff from VK

## Installation

`mix deps.get`

## Config
You need to setup the group names in `group_params.json` (See an example inside).

Also, need to set up access_token below in `config/config.exs`

### Start application
`mix run -e  'VkParser.start_wall_flow' --no-halt`

### Capabilities:
* Right now only image scraping is possible
