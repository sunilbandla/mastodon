# Feedseer

Feedseer is an instance of Mastodon that gives users more control over their feeds.

This is achieved using `qualifiers` and `actions`. `Qualifiers` provide a way to analyze the content of a toot and take action based on that. Based on a qualifier's output, `actions` can be configured to either hide a toot or move it to a folder. Users can create their own qualifiers to analyze different types of toots or provide interesting insights on a toot's content.

> **Feedseer is in Private Alpha. Things will break sometimes and your data may be lost. Our sincere apologies in advance.**

## How to use Feedseer

- Navigate to [Qualifier Store](https://feedseer.com/settings/all_qualifiers).
- Click on a qualifier `name` to see a qualifier's details.
- Read the qualifier `description` to understand the type of analysis performed on a toot.
- Qualifier `endpoint` is where a qualifier is hosted. See the `How to create qualifiers` section below to understand how qualifiers access your toots. Qualifiers cannot access your profile information.
- Add a qualifier to your profile by clicking the `Install` button.
- Click the `Add filter` button to set up an action based on a qualifier's response. The response can be `true` or `false` based on whether or not a toot is related to what the qualifier was looking for.
  - Select a filter condition based on the qualifier's response.
  - Select the action to be taken on a toot that qualifies:
    - Set the action to `Skip Inbox` to remove it from your timelines.
    - Select `Move to folder` and provide a folder name, to move the toot to a folder.
- `Save` the qualifier.
- You can update your qualifier's configuration [here](https://feedseer.com/settings/installed_qualifiers).

> Please write a review for the qualifiers you use so that others can benefit from it. Also, mention the version of qualifier you are reviewing.

## How to create qualifiers

- Navigate to this [page](https://feedseer.com/settings/your_qualifiers).
- Click on `Add qualifier` button.
- Provide a good `name` and `description` for your qualifier.
   - `Description` should include the kind of content a qualifier analyzes and the corresponding response (`true` or `false`) it returns.
- `Endpoint` is the HTTPS URL that will be called with a toot's content.
  - Request will have a `content-type: application/json` header.
  - Request body format will be:
```
{
  "text": "Hello seers!"
}
```
  - Response body format (`content-type: application/json`) should be:

```
{
  "result": true or false (Boolean)
}
```
- `HTTP Headers` will be set on the request sent to your endpoint. It can be used to set authentication headers.
- `Version` can be used to indicate improvements to your qualifier. This helps users review a specific version of a qualifier.
- Select a `category` for the qualifier from the provided list.
- `Save` your qualifier.

> A qualifier will be called only once per toot.

## Roadmap

- Provide more qualifiers out-of-the-box.
- Media toots with qualifiers.
- Granular controls over enabling qualifiers.

![Mastodon](https://i.imgur.com/NhZc40l.png)
========

[![GitHub release](https://img.shields.io/github/release/tootsuite/mastodon.svg)][releases]
[![Build Status](https://img.shields.io/circleci/project/github/tootsuite/mastodon.svg)][circleci]
[![Code Climate](https://img.shields.io/codeclimate/maintainability/tootsuite/mastodon.svg)][code_climate]
[![Translation status](https://weblate.joinmastodon.org/widgets/mastodon/-/svg-badge.svg)][weblate]
[![Docker Pulls](https://img.shields.io/docker/pulls/tootsuite/mastodon.svg)][docker]

[releases]: https://github.com/tootsuite/mastodon/releases
[circleci]: https://circleci.com/gh/tootsuite/mastodon
[code_climate]: https://codeclimate.com/github/tootsuite/mastodon
[weblate]: https://weblate.joinmastodon.org/engage/mastodon/
[docker]: https://hub.docker.com/r/tootsuite/mastodon/

Mastodon is a **free, open-source social network server** based on ActivityPub. Follow friends and discover new ones. Publish anything you want: links, pictures, text, video. All servers of Mastodon are interoperable as a federated network, i.e. users on one server can seamlessly communicate with users from another one. This includes non-Mastodon software that also implements ActivityPub!

Click below to **learn more** in a video:

[![Screenshot](https://blog.joinmastodon.org/2018/06/why-activitypub-is-the-future/ezgif-2-60f1b00403.gif)][youtube_demo]

[youtube_demo]: https://www.youtube.com/watch?v=IPSbNdBmWKE

## Navigation 

- [Project homepage 🐘](https://joinmastodon.org)
- [Support the development via Patreon][patreon]
- [View sponsors](https://joinmastodon.org/sponsors)
- [Blog](https://blog.joinmastodon.org)
- [Documentation](https://docs.joinmastodon.org)
- [Browse Mastodon servers](https://joinmastodon.org/#getting-started)
- [Browse Mastodon apps](https://joinmastodon.org/apps)

[patreon]: https://www.patreon.com/mastodon

## Features

<img src="https://docs.joinmastodon.org/elephant.svg" align="right" width="30%" />

**No vendor lock-in: Fully interoperable with any conforming platform**

It doesn't have to be Mastodon, whatever implements ActivityPub is part of the social network! [Learn more](https://blog.joinmastodon.org/2018/06/why-activitypub-is-the-future/)

**Real-time, chronological timeline updates**

See the updates of people you're following appear in real-time in the UI via WebSockets. There's a firehose view as well!

**Media attachments like images and short videos**

Upload and view images and WebM/MP4 videos attached to the updates. Videos with no audio track are treated like GIFs; normal videos are looped - like vines!

**Safety and moderation tools**

Private posts, locked accounts, phrase filtering, muting, blocking and all sorts of other features, along with a reporting and moderation system. [Learn more](https://blog.joinmastodon.org/2018/07/cage-the-mastodon/)

**OAuth2 and a straightforward REST API**

Mastodon acts as an OAuth2 provider so 3rd party apps can use the REST and Streaming APIs, resulting in a rich app ecosystem with a lot of choice!

## Deployment

**Tech stack:**

- **Ruby on Rails** powers the REST API and other web pages
- **React.js** and Redux are used for the dynamic parts of the interface
- **Node.js** powers the streaming API

**Requirements:**

- **PostgreSQL** 9.5+
- **Redis**
- **Ruby** 2.4+
- **Node.js** 8+

The repository includes deployment configurations for **Docker and docker-compose**, but also a few specific platforms like **Heroku**, **Scalingo**, and **Nanobox**. The [**stand-alone** installation guide](https://docs.joinmastodon.org/administration/installation/) is available in the documentation.

A **Vagrant** configuration is included for development purposes.

## Contributing

Mastodon is **free, open source software** licensed under **AGPLv3**.

You can open issues for bugs you've found or features you think are missing. You can also submit pull requests to this repository, or submit translations using Weblate. To get started, take a look at [CONTRIBUTING.md](CONTRIBUTING.md)

**IRC channel**: #mastodon on irc.freenode.net

## License

Copyright (C) 2016-2018 Eugen Rochko & other Mastodon contributors (see [AUTHORS.md](AUTHORS.md))

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
