# Instructions for SimplexMQ

TODO: some of the below is pending clarification on a minor but important detail from the SimpleX team. This instructions file will be updated once this has been clarified, meaning that an updated version of this package will be provided before going to production.

SimpleX is an Instant Messenger client with sophisticated privacy features. SimplexMQ is a relay server that puts you in control of all DMs that people send you.
This is a beta release of SimplexMQ for your StartOS server. SimpleX has many privacy and configuration options and it's recommended that you get to know them.

It's also important to note that SimpleX itself is in early stages of development, so you might encounter some bugs.

Below is a quickstart guide that will:

- Send as much traffic over Tor
- Enable you to join group chats
- Group messages to you will be delivered (fully encrypted) via SimpleX's servers (over Tor)
- DMs to you will be delivered via your StartOS server
- All DMs to you will be delivered over Tor, hence only other Tor users will be able to DM you
- Small attachments (<8Mb) will be delivered to you via your StartOS server
- Large attachments will be delivered to you (fully encrypted) via SimpleX's servers

# Quickstart Guide - iOS/Android

1. Download the relevant client by following a link on https://simplex.chat/
1. Set up your profile, but click on "Don't create address" (don't click "Create SimpleX address, this will create a receive queue for your DMs on SimpleX's servers)
1. Choose how you want to receive notifications
1. Once in the app, click on your avatar in the top left, then click on "Network & Servers"
1. Set "Use .onion hosts" to "Required"
1. [Optional] On Android, you can enable "Use SOCKS proxy"
1. Click on "SMP Servers"
1. You will see some default servers - smp8, smp9, smp10 for example. These are SimpleX's servers. If you delete all of them, only other Tor users will be able to DM you. 
1. Disable "Use for new connections" on all the smp* servers
1. Click on "Add Server"
1. Click "Scan QR Code"
1. Scan the Server Address under the Properties on your StartOS server
1. Click "Test servers" (you might need to click it twice) then "Save servers"


For more info on client configuration, see these official docs: https://simplex.chat/docs/guide/app-settings.html
## Generate your SimpleX Address

This is a unique QR code that other people can use to connect to you. 

1. Under settings click on "Your SimpleX address", then click on "Create SimpleX address"
1. If this works, you can be certain that your SimplexMQ server is up and running 
1. You can now go back in and re-enable "Use for new connections" on all the smp* servers, this will make your SimpleX more compatible with joining group chats, while ensuring that DMs are sent to you via your StartOS server.

You can now share this address with other users 

# Quickstart Guide - CLI Client

Follow the instructions here https://simplex.chat/docs/cli.html

Once you have the CLI installed, you will launch it like this:

`simplex-chat -s smp://fingerprint=:password@randomhost.onion  --socks-proxy 127.0.0.1:9050`

Note that you need to replace `smp://fingerprint=:password@randomhost.onion` with the value from the Properties on your StartOS server.