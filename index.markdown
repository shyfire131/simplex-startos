---
layout: home
---

SimpleX is possibly the most secure Instant Messenger (IM) client ever developed. Unlike Signal, it does not require a phone number to use. In addition it is fully open source and can be self hosted. It has powerful customizability that might be a bit overwhelming for new users, hence this guide.

Note that SimpleX is beta software.

# What is SimpleXMQ?
SimpleXMQ is a server that runs the SMP protocol and that can receive direct messages from your contacts. 

# How does SimpleX work?
The primary thing to grok about simplex is that YOU tell your contacts WHERE to send your messages (spoiler: you'll be telling them to send them to your StartOS server). Your SimpleX client then checks for messages at this location and downloads them to your client app on your phone or desktop. 

This means that you have full control over where you tell people to send YOU messages, however you have no control over where THEY want THEIR messages delivered. 

To paraphrase, SimplexMQ is a relay server that puts you in control of all DMs that people send you.

Out of the box, a SimpleX setup looks like this (copious amount of detail has been omitted):

![default](/assets/default.png)


However, we want to configure it like this:

![startos](/assets/startos.png)

# Quickstart Guide - iOS/Android

## Initial Setup
1. Download the relevant client by following a link on [https://simplex.chat/](https://simplex.chat/)
1. Set up your profile, but click on "Don't create address" (don't click "Create SimpleX address, this will create a receive queue for your DMs on SimpleX's servers which is what you don't want)
1. Choose how you want to receive notifications
1. Once in the app, click on your avatar in the top left, then click on "Network & Servers"
1. Set "Use .onion hosts" to "Required"
1. [Optional] On Android, you can enable "Use SOCKS proxy"
1. Click on "SMP Servers"
1. You will see some default servers - smp8, smp9, smp10 for example. These are SimpleX's servers. If you delete all of them, only other Tor users will be able to DM you. 
1. Disable the "Use for new connections" setting on all the smp* servers
1. Click on "Add Server"
1. Click "Scan QR Code"
1. Scan the Server Address under the Properties page on your StartOS service for SimpleXMQ
1. Click "Test servers" (you might need to click it twice) then "Save servers"
1. Click back 


For more info on client configuration, see these official docs: [https://simplex.chat/docs/guide/app-settings.html](https://simplex.chat/docs/guide/app-settings.html)
## Generate your SimpleX Address

This is a unique QR code that other people can use to connect to you. 

1. Under the root settings menu, click on "Your SimpleX address", then click on "Create SimpleX address"
1. If this works, you can be certain that your SimplexMQ server is up and running 

You can now share this contact address with other users over another trusted channel such as text message, email, etc. 

**Note:** sharing this initial out of band message is a core part of the SMP protocol, and is described in more detail here: [https://github.com/simplex-chat/simplexmq/blob/stable/protocol/simplex-messaging.md#out-of-band-messages](https://github.com/simplex-chat/simplexmq/blob/stable/protocol/simplex-messaging.md#out-of-band-messages)

Also note that in this mode, only small (<8Mb) attachments will be sent over your StartOS server. If there is demand, I will add support for large files via SimpleX XFTP. Let me know!

## Advanced - Interoperability Mode

With some effort, it's possible to use SimpleX in hybrid mode where you have self-hosted chats with Tor users, but also chat with non-Tor users. It would look something like this:

![startos-advanced](/assets/startos-advanced.png)

This basically requires toggling the "Use for new connections" toggle whenever you a) make a new connection or b) join a public chat. If you join a new group and you want everyone to send to you over your StartOS server, disable all the smp* servers and enable your StartOS server. Alternatively, if you want a new contact or new group you are joining to be able to contact you over clearnet / without Tor, then enable all the smp* servers and disable your StartOS server.

Note that SimpleX will randomly select a receive server if you have multiple enabled.

# Quickstart Guide - CLI Client

Follow the instructions here https://simplex.chat/docs/cli.html

Once you have the CLI installed, you will launch it like this:

`simplex-chat -s smp://fingerprint=:password@randomhost.onion  --socks-proxy 127.0.0.1:9050`

Note that you need to replace `smp://fingerprint=:password@randomhost.onion` with the value from the Properties on your StartOS server.


## Appendix - random points
- Large attachments will be delivered to you (fully encrypted) via SimpleX's servers
- Even when using the smp* servers, there is no identity and everything happens over Tor
- Very good description of the SMP protocol: [https://github.com/simplex-chat/simplexmq/blob/stable/protocol/simplex-messaging.md](https://github.com/simplex-chat/simplexmq/blob/stable/protocol/simplex-messaging.md)
