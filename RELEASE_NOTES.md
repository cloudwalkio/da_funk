# DaFunk

### 2.0.0 - 2018-10-02

- Support check specific listener type;
- Adopt ThreadScheduler and stop all thread at boot end;
- Remove status bar check from engine loop;
- Add Support to change link/unlink payment channel image.
- Fix IO_INPUT_NUMBERS string change at IO.get_format

### 1.13.1 - 2018-08-29

- Fix ScreenFlow navigation when comparing confirmation.

### 1.13.0 - 2018-08-17

- Add DaFunk::ParamsDat::parameters_load copy of ready?.
- ScrenFlow.confirm returns boolean.
- Support schedule events in file if using hours parameters.

### 1.12.0 - 2018-08-09

- Do not raise exception when bitmap to be display doesn’t exists.
- Implement Device::Priter.print_barcode.

### 1.11.2 - 2018-07-02

- Fix ISO8583 bitmap parse when greater than 64 bytes.

### 1.11.1 - 2018-05-22

- Add Nil.integer?

### 1.11.0 - 2018-05-18

- Bug fix String.integer? when string starts with “0”.
- Increase getc timeout to 10 seconds when communication error.
- ISO8583 convert bitmap from binary to hex and hex to binary.

### 1.10.0 - 2018-03-22

- Change Notification format removing repeated values.

### 1.9.0 - 2018-03-02

- Replace shutdown by teardown, more appropriated for
application loop.

### 1.8.0 - 2018-03-02

- Implement Device::System::shutdown.
- Implement Device::Setting::heartbeat ParamsDat check.

### 1.7.1 - 2018-02-09

- Fix payment channel compilation.

### 1.7.0 - 2018-02-09

- Adopt “w” for FileDb and Transaction::Download write operation and improve IO time.
- Implement ConnectionManagement class based on ParamsDat config.
- Implement PaymentChannel via websocket.

### 1.6.0 - 2018-02-01

- Implement Notification#reply.
- Temporarily remove I18n require.

### 1.5.0 - 2018-01-24

- Implement Network::configure to split Network::init in two parts, configure for the definition of the interface, and init it self the system call.

### 1.4.4 - 2018-01-24

- Fix Screen.add when column is missing.

### 1.4.3 - 2018-01-18

- Refact automatic menu header reviewing limits.

### 1.4.2 - 2018-01-17

- Extract background pagination helper.
- Refactoring menu helper to support footer, header
and background customization.

### 1.4.1 - 2018-01-17

- Fix Notification parse to make communication management works.

### 1.4.0 - 2018-01-16

- Refactoring String.integer? And String.to_i adding more tests and support big numbers integer check.
- Implement Screen.add to print and update x and y.
- Support to print background image on menu if title path exists.
- Update cloudwalk (1.4.0).
-  Do no print menu entry if empty.

### 1.3.1 - 2018-01-12

- Fix String.integer? Method supporting Float.

### 1.3.0 - 2018-01-12

- Call String.to_f when reached Integer conversion limit.

### 1.2.0 - 2018-01-11

- Remove NotificatioTest, it’s outdated.
- Fix DaFunk::Application test when receiving a label that wasn’t expected.
- Replace crc16 of downloaded files strategy instead of read the entire file move the responsibility to decide the better approach, 1. Read the entire file, 2. Read each 10k. It’s necessary to avoid a system error on File.read greater than 900k.
- Finish the excecution after custom test run to avoid rake to try run a task with the file name.
- Check if file is bigger than 500k on Crypto::file_crc16_hex and if it is, calculate the crc in chuncks.
- Implement Float.to_s with other bases 10, nil and others.
- Refactoring String.to_i adopting Interger() instead of alias.
- Add Float tests.
- Fix Display Test covering MRuby 1.3.0 puts/print API.
- Refactoring NotificationEventTest following the new implementation.

### 1.1.1 - 2018-01-10

- Update dependencies versions.

### 1.1.0 - 2018-01-10

- Rename Device::Printer#set_font to Device::Printer#font.
- Fix #18 - Adopt Integer instead of Fixnum.
- Check if adapter isn’t nil before check Crypto class.
- Fix Float.to_s method generating implementing Alis for the old.
- Refact String.to_i implementing alias for the old.
- Refact number_to_currecy float test.

### 1.0.0 - 2018-01-04

- Remove serfs interface and implement notification
interface via web socket.
- Adopt ContextLog to store error on file download.
- Implement force parameter to application, params dat and file download.
- Unzip ruby application after download instead of execution call.
- Move Application, Notification*, ParamsDat and Transaction from Device to Dafunk scope.
- Remove transaction/emv.rb and refactor loads.
- Remove Device:Helper.
- Check if application file exists before return local crc.
- Adopt custom exception for Application download.
- Force unzip ruby application if file is the same.
- Do not cache local crc on DaFunk::Application.
- Adopt DaDunk::Application CRC check strategy in DaFunk::FileParameter

### 0.28.0 - 2017-12-07

- Support to interrupt file download if KEY CANCEL pressed.

### 0.27.0 - 2017-12-04

- Update rake dependency.

### 0.26.0 - 2017-11-28

- Change default serf notification creation timeout to 180 seconds.
- Support new MessagePack syntax.

### 0.25.0 - 2017-11-27

- I18n, check if the current language was already configure to perform the merge options.
- Add Support tests.
- Implement String#snakecase.

### 0.24.0 - 2017-11-08

- Update ext/float.rb to compilation.

### 0.23.0 - 2017-11-08

- Implement String#to_big.
- Implement custom Float#to_s(16).

### 0.22.0 - 2017-11-04

- Bug fix Device::Network.attach_timeout when dealing with wifi.
- Always shutdown interface after communication error.

### 0.21.0 - 2017-11-03

- Implement custom Device::Setting.attach_gprs_timeout.
- Adopt custom GPRS timeout on Network.attach.
- Adopt temporary processing returns at Device::Network.attach.

### 0.20.0 - 2017-10-31

- Adopt connection_management 1 as default.

### 0.19.0 - 2017-09-14

- Update README_GUIDE.

### 0.18.0 - 2017-09-14

- Update README_GUIDE.

### 0.17.0 - 2017-09-13

- Update README_GUIDE.

### 0.16.0 - 2017-09-04

- Implement custom print at attach helper.

### 0.15.0 - 2017-08-30

- Add task to setup(initialize) Network based in the current configuration.
- Reload Network, Setting and ParamsDat after app execution.

### 0.14.0 - 2017-08-28

- Add task to pack application.
- Fix cloudwlak run call at rake task.

### 0.13.0 - 2017-08-16

- Implement tcp_recv_timeout as custom attribute at Device::Setting.

### 0.12.0 - 2017-08-14

- CommandLinePlatform.connected? return 0.

### 0.11.0 - 2017-08-10

- Fix connection_management flag

### 0.10.0 - 2017-08-08

- Define pt-br as default locale.
- Implement Kernel#print_last.
- Adopt print_last for Herlper#attach.
- Implement Device::Network.shutdown, what call disconnect and power(0).
- Update cloudwalk_handshake (0.9.0), funky-emv (0.9.0) and posxml_parser(0.16.0).

### 0.9.2 - 2017-07-25

- Refactoring Network.configured? fixing the return which must be a bool.
- Create Device::Setting.wifi_password and Device::Setting.apn_password.

### 0.9.1 - 2017-07-12

- Fix file deletable check and extra parameters for additional files at ParamsDat.format!.

### 0.9.0 - 2017-07-05

- ParamsDat.format! support parameter to keep platform bmp images.

### 0.8.6 - 2017-06-30

- Support to alpha chars at Device::IO.get_format.

### 0.8.5 - 2017-06-22

- Bug fix EventHandler timer control.

### 0.8.4 - 2017-06-13

- Refactoring status bar management removing interval and increase last 100% png range.

### 0.8.3 - 2017-05-29

- Fix typo in EventListener.delete.

### 0.8.2 - 2017-05-12

- Add boot flag to Device::Setting.

### 0.8.1 - 2017-03-05

- Support CANCEL and TIMEOUT at form and implement default as current value.
- During ParamsDat application and files update only show outdated ones.
- Replace Exception by StandardError for ISO8583Exception.

### 0.8.0 - 2017-01-26

- Implement white list for IO.get_format inputs.
- Add a different return for key timeout at IO.get_format.
- Stable version.

### 0.7.19 - 2017-01-20

- Change print big size to (16, 32, 16, 23).

### 0.7.18 - 2016-12-14

- Bug fix tracks digits comparing at Magnetic.

### 0.7.17 - 2016-12-13

- Refactoring Magnetic#bin? to check Range/value size to extract digits from track2.

### 0.7.16 - 2016-12-01

- Bug fix to String#to_mask when mask greater than value.

### 0.7.15 - 2016-12-01

- More descriptive ISO8583 exception including field name.

### 0.7.14 - 2016-11-24

- Implement a way to disable StatusBar management by DaFunk.

### 0.7.13 - 2016-11-22

- Add support to Device::Setting#heartbeat.

### 0.7.12 - 2016-10-14

- Bug fix Crypto class check.
- Remove commented code at struct.rb.
- Bug fix replace Device::Setting.sim_pim by sim_pin.

### 0.7.11 - 2016-10-07

- Do not start a new runtime for POSXML.

### 0.7.10 - 2016-10-06

- Refactoring Helper.menu supporting custom forward and back key, and bug fix pagination.
- Support custom forward and back keys.

### 0.7.9 - 2016-10-03

- Implement seconds to Scheduler timer.
- Implement Device::IO.getxy to support touchscreen.
- Adopt try_user in Device::Network.
- Implement Helper#try_user to implement a user interruption.
- Use getc(milliseconds) instead of sleep to improve UX in Helper.
- Replace ContextLog.error by ContextLog.exception.
- Adopt DaFunk::Struct instead of Struct in Notifications.
- Send a Serf#event if creation interval exceed.
- Fix leak I18n copying translation in every call.
- Close serf socket if command has no reply.
- Implement DaFunk::Struct to avoid memory leaks from mruby.
- Check key cancel and return it at get_format.
- Update README.

### 0.7.8 - 2016-09-20

- Fix windows system call in bin checks.

### 0.7.7 - 2016-09-20

- Fix system call in cygwin environment.

### 0.7.6 - 2016-09-08

- Bug fix bitmap 128 bits size generation.

### 0.7.5 - 2016-09-06

- Refactoring Magnetic#bin? adding properly checking if read.
- Bug fix check if Magnetic adapter opened correctly.
- Remove rescue exception in CommandLinePlatform to avoid hide any error.

### 0.7.4 - 2016-04-15 - Small changes

- Add timer type EventListener.
- Change attach helper to check if Network is configured.
- Add key ALPHA to change between alpha chars on get_format.
- Store response from open in Magnetic object.
- Log error if exception error in file download.
- Bug fix in key value parse at FileDb supporting more than one “=“.
- Bugfix ISO8583 exception handler.
- Refactoring ScreenFlow
    - Rename add method to screen.
    - Remove order, now the order is defined by the screen method call order.
    - Add screen_methods and screen attributes.
    - Add support for setup method, to be called every time before start a screen.
- Add support for line and column on I18n.pt method.
- Add support for crc generation from a file.
- Refactoring download method from ParamsDat class rename tried variable for attempt.
- Add Device::System.update.
- Refactoring Crypto crc’s functions to use internal implementation in C from Device if available.
- Refactoring StatusBar battery display and add support to power_supply from Device.
- Fix String#integer? to work mRuby 1.2.

### 0.7.3 - 2016-04-15 - Small changes

- Implement NilClass#to_big.
- Load I18n main file if try to use.
- String#integer? return true if string[0] is “0”.
- On Notification implement force parameter to create fiber when fiber is dead.

### 0.7.2 - 2016-03-30 - gemspec problem

- Fix gemspec problem on the list of files.

### 0.7.1 - 2016-03-30 - Small changes

- Refactoring Application to calculate crc on the end of download to check integrity.
- During attaching process define network_configured = 1 if attached successfully.
- Fix crc generation on download file if crc didn’t come.
- Update posxml_parser to version 0.7.10.

### 0.7.0 - 2016-03-10 - EventListener and EventHandler

- Implemented method each for FileDb.
- Implement method to_json to array and hash on an extension.
- Extract app_loop method from Device to DaFunk::Engine.
- Implement method Magnetic#bin? to change range read.
- Implement EventListener and EventHandler to deal with custom events.
- Remove Notification setup from app_loop and DaFunk responsibility.
- Change status bar update timeout to 60 seconds.
- Implemented Magnetic#read? to check if status is STATUS_SUCCESSFUL_READ.
- Update posxml_parser to version 0.7.6.

### 0.6.7 - 2016-02-29 - DaFunk::Engine and DaFunk::StatusBar

- Refactoring screen string manipulation.
- Only call signal if Network connected.
- Bug fix, only consider Network configured if Device::Setting.media is defined and Device::Setting.network_configured is 1.
- Implement DaFunk::Engine and support to display status bar icons(battery, wifi and mobile).
- Add support to remove all files from ./shared/ on Device::ParamsDat.format!(excluding main.bmp).
- Device::Display.main_image check if platform respond_to main_image and if the file exists to return the method.
- Update posxml_parser to version 0.7.3.

### 0.6.6 - 2016-02-18 - Update map keys adding some special chars

- Update map keys adding some special chars.
- Finally remove da_funk binary file from git source, the binary will package on release only(rubygem).

### 0.6.5 - 2016-02-18 - Implement keys map on input functions

- Update cloudwalk_handshake to version 0.5.4.
- Implement Device::IO.setup_keyboard to map keys on input functions.
- On Device::Transaction::Download rescue SocketError returning COMMUNICATION_ERROR.

### 0.6.4 - 2016-02-16 - Update cloudwalk_handshake

- Update cloudwalk_handshake to version 0.5.3.
- Add DaFunk::VERSION to define da_funk version.
- Change Device.version to define platform/device version.
- Fix Printer.check, syntax error.

### 0.6.3 - 2016-02-12 - Update cloudwalk_handshake

- Update cloudwalk_handshake to version 0.5.2.

### 0.6.2 - 2016-02-12 - Update da_funk binary

- Update da_funk binary.

### 0.6.1 - 2016-02-12 - Update posxml_parser

- Update posxml_parser to version 0.7.2.
- Replace simplehttp for funky-simplehttp from rubygems.

### 0.6.0 - 2016-02-02 - Support to i18n.
- Add support to i18n.
- Add I18n messages to ParamsDat/Files/Apps downloading.
- Add support to ISO8583 file parser.
- Implemented DaFunk::Helper#try_keys to abstract a helper responsible to wait for range of key only in a period.
- Implement classes CallbackFlow and ScreenFlow to abstract the development of complex screen flows.
- Refactoring Device::IO.get_format.
- Rjust Device::Crypto.crc16_hex return, 4 chars with “0”.
- Add support to current value on Device::IO.get_format.
- Send file CRC on file download.
- Implement String#integer?.
- Fix number_to_currency to not include label after conversion.
- Add pagination on Helper.menu.
- FileDb always work with key and values as string.
- Fix System Error during Notification Fiber catching all communication exceptions.
- Update cloudwalk_handshake version to 0.5.1.
- Update posxml_parser version to 0.7.1.
- Update readme file.

### 0.5.4 - 2016-01-08 - Update posxml_parser
- Update posxml_parser to version 0.6.1.

### 0.5.3 - 2016-01-06 - Update cloudwalk_handshake
- Update cloudwlak_handshake to version 0.5.0.
- Support to execute an application as file.

### 0.5.2 - 2016-01-05 - Update cloudwalk_handshake
- FileDb dot not check key value after sanitize to avoid problem on hash creation.
- Add sim_pim, sim_slot, sim_dual, phone, modem_speed, touchscreen, attach_gprs_timeout, attach_tries, tcp_recv_timeout, iso8583_send_tries, crypto_dukpt_slot and ctls to Setting.
- Add method model and versions to Device::System.
- Add support to brand, model and versions to DaFunk tests API.

### 0.5.1 - 2015-12-16 - Update cloudwalk_handshake
- Update cloudwlak_handshake to version 0.4.12.

### 0.5.0 - 2015-12-14 - Wifi scan
- Add support to Wifi scan.
- Add support to check GPRS and Wifi signal.
- Fix notification socket reading.

### 0.4.20 - 2015-12-10 - Refactoring Notification
- Implement try method on helper to be use on by communication tries.
- Serfx#auth now receives the authentication key as a parameter too, so that could be called externally in a determined moment, example TOTP authentication on the right moment (after socket open, avoiding authentication problems).
- Treat authentication error clearing cw_pos_timezone to perform entire handshake on next time.
- Make Device::Display.print call STDOUT.print if row and column are not sent.
- On Device::Display#clear call STDOUT.fresh to change the Screen state to 0(x and y).
- Refactor download of file on ParamsDat to implement method try, adopted initially 3 times.
- On Screen.setup define STDOUT on Object, instead of Kernel.
- Update cloudwalk_handshake to version 0.4.11.
- Fix Screen jump line to not jump before print if size is less than max_x.
- Support to keep alive Notifications restarting in intervals.
- On Notification Callback to display message use `getc(0)` (wait a key to be pressed forever) instead of getc(nil) (wait a key to be pressed in default time.
- Implement String#chars extension.
- Support to execute a unique file test, example: `rake test test/unit/file_test.rb`.

### 0.4.19 - 2015-12-04 - Refactoring Device::Setting.to_production!/.to_staging!
- Implement FileDb#update_attributes to update more than one key in a unique save.
- Refactoring Device::Setting.to_production!/.to_staging! to clean company_name if the last environment is different.
- Update cloudwalk_handshake version to 0.4.7.
- Fix debug flag setup to check if is_a? FalseClass class to define true/false.

### 0.4.18 - 2015-12-03 - Automatically configure Application running
- Automatically configure Application running.

### 0.4.17 - 2015-12-01 - Update CloudWalkHandshake
- Update CloudWalkHandshake to version 0.4.6.

### 0.4.16 - 2015-11-27 - Serial and logical_number configuration on rake test
- Support to serial and logical_number configuration on rake test.

### 0.4.15 - 2015-11-24 - Screen limitation abstraction
- Implement class Screen to replace STDOUT and perform column and line display abstraction on place that doesn’t support screen display by STDOUT.

### 0.4.14 - 2015-11-23 - Improve IO functions
- Update cloudwalk_handshake to version 0.4.5.
- Apply relative path on compilation and tests paths to make it work properly on windows.
- Move from Print to Printer.
- Implement Device::Print.print_big.
- Support to display in line at Device::IO.get_format.
- On Helper.menu support Device::IO.timeout if timeout isn’t send.
- Refactoring the documentation of Helper.menu.
- Refactoring Device::IO.get_format: Add support masquerade values; Improve the input letters and numbers; Add input alpha.
- Add the compilation of lib/ext/string.rb on Rakefile.
- Implement ISO8583 fields Unknown, XN(BCD), LLLVAR_Z and Z (LL Track2).
- Add iso8583_recv_tries setting.
- Add uclreceivetimeout to Setting.
- Add ISO8583::FileParser to parse bitmap.dat file.


### 0.4.13 - 2015-10-30 - Implement get_string byt getc
- Implement Debug Flag.
- Fix Device::IO.change_next to return the first option and restart the loop.
- Refactor System.restart/reboot
- Implement timeout on Device::IO.
- Send nil to getc when show notification message to be blocking.
- Invert the check of string size on get_string.
- Use default timeout to menu getc.
- Call IO::ENTER adding Device:: scope on helpers.
- Change Device::IO.get_string to work only by getc formatting letters and secret. - Implement DeviceIOTest class.

### 0.4.12 - 2015-09-02 - helper on ISO8583 load
- Bug fix helper load on iso8583.

### 0.4.11 - 2015-09-02 - Minor fixes and ISO8583
- Bug fix strip key and value strings of FileDb.
- Add FileDb#sanitize to strip and clean string(from quotes).
- Update connection message.
- Remove application crc check for while.
- Add UI message to Notification process.
- Fix application selection when just a single application is available.
- Create DaFunk::Helper from Device::Helper.
- Isolate ISO8583 to be load individually by require, `require 'da_funk/iso8583'`.

### 0.4.10 - 2015-08-14 - Check CRC during App Update
- Update CloudwalkHandshake version.
- Support to check CRC during app update, avoiding unnecessary download.
- Fix Helper class Documentation.

### 0.4.9 - 2015-08-04 - CloudwalkHandshake loading fix
- Fixes problem to load CloudwalkHandshake.

### 0.4.8 - 2015-07-29 - CloudwalkHandshake as dependency
- Add CloudwalkHandshake as dependency.

### 0.4.7 - 2015-06-09 - New Notication Spec
- Fix gem out moving on mrb compilation.
- Abstract CloudWalk Handshake to other gem.
- Support new CloudWalk Notifcation spec.
- Support Notification timezone update.
- Support Notification show message.
- Changed Notification event check timeout for 5 seconds.

### 0.4.6 - 2015-06-12 - Timezone Setting
- Support cw_pos_timezone.
- Support cw_pos_version.

### 0.4.5 - 2015-06-09 - ISO8583, environment and abstraction classes
- Implementing support to change host environment configuration with Setting.to_production! and Setting.to_staging!.
- Fix da_funk.mrb out path getting the app name to output da_funk.mrb.
- Add tests to FileDb and ParamsDat.
- Improve README adding chapters about AroundTheWorld project.
- Add return 7 to Device::System.battery, which means power supply connected and has no battery.
- Support to Network::Ethernet abstraction.
- Support to Print abstraction.
- Fix number_to_currency on the 1.1.0 mruby version.
- Update ISO8583 library.

### 0.4.4 - 2015-03-27 - Gemspec summary and description.
- Fix gemspec summary and description.

### 0.4.3 - 2015-03-27 - Refactoring Display interface
- Support resource configuration in DaFunk RakeTask.
- Refactoring IO/Display and UI methods.

### 0.4.1 - 2015-03-10  - Small fixes and notifications
- Implement Serf protocol by serfx port.
- Support CloudWalk Notifications.
- Support to execute unit and integration tests.
- Fix check ssl = "1" to start handshake.
- Fix verify handshake return to fail handshake.
- Fix download by SSL, check received packet to increment downloaded size. It is posible to SSL interface return hald of asked size in the midle of process.
- Support to mruby and mrbc binary configuration at rake task creation.
- Implement Helper.rjust/ljust.
- Implement CommandLinePlatform to perform integration tests.
- Implement Zip class to abstract zip/unzip operations.
- Implement Magnetic class to abstract magnetic card read.

### 0.3.2 - 2014-12-24 - First stable Version