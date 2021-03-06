# DaFunk

### 3.33.1 - 2021-02-19

- Fixed argument being passed to hours2seconds method which was nil;

### 3.33.0 - 2021-02-08

- Added method Device::IO#get_format_or_touchscreen_action;
- Added support to images on ParamsDat#download, ParamsDat#update_app and ParamsDat#update_file;
- Return result of ParamsDat#update_apps call to the caller.

### 3.32.0 - 2021-01-04

- Remapped virtual keyboard to add support to new layout;
- Make timeout of virtual keyboard parametrized;
- Limit size of string to 20 on virtual keyboard;
- Refactoring status bar:
  - Check if thread is paused which means communication it's being configured. In this case 'sem sinal' message should be displayed;
  - Do not show media type an media icon if thread is paused;
- Removed thread pause from attach and scan calls, let the application that is doing the configuration take care of that;
- Move reload of metadata to communication thread;
- Added support to check network conn status from time to time, default is each 5 minutes.

### 3.31.0 - 2020-11-27

- Added support to new battery view (Exact percentage);
- Added support to new main screen when there's a pending sale.

### 3.30.0 - 2020-11-16

- Replace GPRS icon to 3G;
- Added new method main_image_format on Device::Display;
- Use main_image_format method to get the image name instead adapter;
- Added new class DaFunk::Transaction::Reversal.

### 3.29.1 - 2020-11-04

- Fix battery charging status. When power supply is connected the SDK always returns 50% of battery, in this case it won't show the percentage until the SDK returns 100%.

### 3.29.0 - 2020-11-03

- Added support to Ruby SecureRandom;
- Update cloudwalk_handshake (1.21.3).

### 3.28.2 - 2020-10-07

- Added support of params.dat file restore if it was corrupted;
- Wait 3 seconds before restart after main update;
- Fixed method_missing exception;

### 3.28.1 - 2020-09-26

- Close socket in case of ssl exceptions;
- Do not assign nil to PaymentChannel#current and client on error because this is already being done on PaymentChannel#close.

### 3.28.0 - 2020-09-25

- Check if system update file is present after device restart in order to continue with system update process;
- Implemented block to write and break line if message has '\n'.

### 3.27.0 - 2020-09-25

- Print bitmap if exists on DaFunk::ParamsDat#restart;
- Add main application version on config.dat file.

### 3.26.0 - 2020-09-14

- Fixed error on virtual keyboard, chars y and Y were duplicated;
- Update cloudwalk_handshake (1.20.0).

### 3.25.1 - 2020-08-28

- Set DaFunk::Helper::StatusBar#connected as false on system update process so it will cache again.

### 3.25.0 - 2020-08-18

- Added switch_http_enabled setting;
- Removed infinitepay_authorizer and infinitepay_api settings.

### 3.24.4 - 2020-08-07

- Add defensive code to gsub calls.

### 3.24.3 - 2020-08-03

- Fixed path name on DaFunk::Application

### 3.24.2 - 2020-08-01

- Do not remove company name to file path when ruby app

### 3.24.1 - 2020-07-27

- Infinitepay authorizer setting 1 as default.

### 3.24.0 - 2020-07-25

- Added Device::Signature class;
- Added support of converting signature after updating params.dat;
- Added support to network state on status bar;
- Added support to physical number keys on virtual keyboard.

### 3.23.0 - 2020-06-22

- Remove ThreadPubSub publication before attach;
- Update funky-emv (1.4.1).

### 3.22.0 - 2020-06-18

- Update libs:
  - cloudwalk_handshake (1.14.0)
  - funky-emv (1.4.0)

### 3.21.2 - 2020-06-16

- Fixed timeout return on DaFunK::Helper#menu, it should return Device::IO::KEY_TIMEOUT not options[:timeout];
- Set cloudwalk endpoint as default.

### 3.21.1 - 2020-06-16

- Fix error when timeout on DaFunk::menu_image_touchscreen_or_keyboard.

### 3.21.0 - 2020-06-12

- Removed unnecessary processing method call;
- Status bar refactored:
  - Removed link icon;
  - Added support to SLOT_MEDIA to print WIFI or GPRS;
  - Renamed SLOT_CONNECTION to SLOT_SIGNAL_LEVEL;
  - Added support to SLOT_BATTERY_PERCENTUAL to print percentual of battery level;
  - Renamed SLOT_BATTERY to SLOT_BATTERY_LEVEL;
  - Update battery and wifi images;
  - Added BATTERY_PERCENTAGE_IMAGES;
  - Show searching icon when network is not connected;
- Added support to virtual keyboard;
- Added support to touchscreen event on DaFunk::Helper#menu;
- Added support to return timeout parameter on DaFunk::Helper#menu when timeout is achieved;
- Update funky-emv 1.3.0.

### 3.20.0 - 2020-05-28

- Rename PaymentChannel::client to ::current;
- Fix status bar change link to cache old value.

### 3.18.1 - 2020-05-20

- Fix issue on DaFunk::Helper#menu_image_touchscreen_or_keyboard it was not checking for special keys

### 3.18.0 - 2020-04-03

- Added enable_txt_ui parameter on the following methods
 - DaFunk::ParamsDat#download;
 - DaFunk::ParamsDat#update_apps;
 - DaFunk::ParamsDat#update_app;
 - DaFunk::ParamsDat#update_file;
 - DaFunk::Helper#attach_options;
 - DaFunk::Helper#check_download_error;

### 3.17.0 - 2020-02-10

- Added support to infinitepay endpoints config on config.dat file;
- Update cloudwalk (1.15.0);
- Update cloudwalk_handshake (1.13.0);

### 3.16.3 - 2020-01-31

- Changed setting emv_input_amount_idle to emv_contactless_amount.

### 3.16.2 - 2020-01-29

- Moved responsability of beep sound for touch event to DaFunk::Helper#parse_touchscreen_event;
- Call Audio class from adapter instead PAX.

### 3.16.1 - 2020-01-28

- Added beep only when we've a successful interaction on the touch menu, avoiding beep when the click was outside the screen button.

### 3.16.0 - 2020-01-28

- Added beep handling when touchscreen successful event.
- Added FileDb#each_with_index method;
- Changed DaFunk::Helper#menu return, now it will return nil if key pressed is CANCEL.

### 3.15.1 - 2020-01-17

- Just removed some debug points

### 3.15.0 - 2020-01-16

- Load/update config.dat file before set payment channel attempts;
- Update cloudwalk_handshake (1.11.0);
- posxml_parser (2.26.0);

### 3.14.0 - 2019-12-30

- Update cloudwalk_handshake (1.10.0);
- Load metadata after successfully attach;
- Support Device::Setting::network_init to improve network initialisation control;
- Notify all threads that modifications on network was made;

### 3.13.1 - 2019-12-18

- Update funky-emv (1.2.2);
- Update cloudwalk_handshake (1.9.0);

### 3.13.0 - 2019-12-03

- Added funky-mock library;
- Add status bar spinner to system update;
- Support background update;
- Refactoring touch events handling.

### 3.12.4 - 2019-11-28

- Bug fix on wait_touchscreen_or_keyboard_event. Use getxy instead getxy_stream to clean up events queue.

### 3.12.3 - 2019-11-22

- Duplicate string before mrb_eval to avoid possible memory leak.

### 3.12.2 - 2019-11-18

- Bug fix undefined method 'x' on parse_touchscreen_event. This method was not receiving x and y which were local variables.

### 3.12.1 - 2019-11-18

- Bug fix local jump error: unexpected return. Error found on methods added to touch screen operations (Helper).

### 3.12.0 - 2019-11-14

- Added DaFunk::Helper#wait_touchscreen_or_keyboard_event.
- Added Added DaFunk::Helper#menu_image_touchscreen_or_keyboard.

### 3.11.1 - 2019-10-24

- Fixed method call on ISO8583Exception rescue.

### 3.11.0 - 2019-09-26

- Implemented processing method helper which can show processing image or text while runtime is starting a ruby application.
- Update cloudwalk_handshake (1.8.1)
- Update posxml_parser (2.24.0)

### 3.10.6 - 2019-08-11

- Fix more encoding problems ISO8583 Bitmap and Message.

### 3.10.5 - 2019-08-10

- Force encoding of mti value on ISO8583 message to_b.

### 3.10.4 - 2019-08-09

- Removed the name from the path for uncompress main. It was crashing the unzip process and breaking the update;
- Fix ISO8583 bmp encoding error.

### 3.10.3 - 2019-07-26

- Check if ContextLog exists on ISO8583 field.rb;
- Refactoring ISO8583 Null_Codec decoder to avoid encoding error.

### 3.10.2 - 2019-07-09

- Fix main application detection on app update;
- Support cloudwalk_handshake (1.6.0).

### 3.10.1 - 2019-07-09

- Fix application set loop on PaymentChannel and System.

### 3.10.0 - 2019-07-08

- Do not raise load error when cloudwalk_handshake doesn’t exists;
- Support to app set on PaymentChannel;
- Set PaymentChannel application on Device::System::klass=;
- Support CwHttpEvent on PaymentChannel.

### 3.9.0 - 2019-06-18

- Support to uncompress main application and reboot after it.

### 3.8.3 - 2019-06-18

- Added emv_input_amount_idle parameter on config.dat.

### 3.8.2 - 2019-06-18

- Implemented Params::ruby_executable_apps, helper to select only ruby applications even if not executable;
- Fix ISO 8583 HEX Bitmap generation.

### 3.8.1 - 2019-06-13

- Fix ISO8583 binary bitmap generation to CRUBY.

### 3.8.0 - 2019-06-06

- Do not send host/port information to CwHttpSocket, let it deal with host and port config from config.dat and/or params.dat;
- Added infinitepay_authorizer and infinitepay_api on config.dat;
- Divide Runtime execution in two steps, start (application loading) execute (application execution);
- Support to cache an application after downloading;

### 3.7.0 - 2019-05-22

- Added support to get http code status using payment channel interface.

### 3.6.0 - 2019-05-21

- Avoid memory leak on EventListener, avoid cleaning memory duplicating object;
- Check if ContextLog object exists on ISO8583.

### 3.5.0 - 2019-05-13

- Fix time range exception on schedule.

### 3.4.0 - 2019-05-13

- Do not remove old files and application on params.dat.

### 3.3.1 - 2019-05-13

- Mock Device::Setting.logical_number from System if empty.

### 3.3.0 - 2019-05-07

- Remove communication errors from PaymentChannel;
- Remove unnecessary MAC address log;
- Implement ConnectionManager.check (from PaymentChannel).

### 3.2.1 - 2019-04-11

- Fix Dir removal on Application.delete.

### 3.2.0 - 2019-03-14

- Support menu_image helper that display image for menu.

### 3.1.1 - 2019-03-14

- Bug fix attach helper loop image and decrease display time to 200ms;
- Bugfix flag PaymentChannel::transaction_http use PaymentChannel didn’t change to payment channel approach when demand;
- Bug fix extend timeout to PaymentChannel handshake.

### 3.1.0 - 2019-03-12

- Replace host config for http.

### 3.0.0 - 2019-02-28

- Replace payment channel interface from WebSocket to HTTP;
- Support config.dat parameters `transaction_http_enabled`, `transaction_http_host`, `transaction_http_port`.

### 2.7.1 - 2019-02-16

- Bug fix set payment channel limit disable as default.

### 2.7.0 - 2019-02-16

- Execute ThreadScheduler::keep_alive every engine check
- Refresh every file on every FileDb set method if key is boot, this is a temporary fix to avoid edit problem between threads;
- Add Device::Setting attributes, payment_channel_attempts - To count channels in a day; payment_channel_date - Connection day;
- Implement Device::Setting::payment_channel_set_attempts, it’s a simple helper to set both payment_channel_date and payment_channel_attempts;
- Implement channel connection limit configuration.

### 2.6.0 - 2019-02-14

- Support to Device::Runtime::reload on Engine stop.

### 2.5.1 - 2019-02-07

- Fix EventHandler rescheduler when dealing with slots.

### 2.5.0 - 2019-02-05

- Bug fix EventHandler with slot configuration
    - Fix timestamp when configuration has changed;
    - Fix execution between boots.

### 2.4.0 - 2019-01-14

- Support Device::Network.mac_address.

### 2.3.0 - 2018-12-28

- Implement Device::Setting.metadata_timestamp;
- Implement access to configuration at Device::Setting.

### 2.2.0 - 2018-12-04

- Support pausing communication on Network::scan.

### 2.1.0 - 2018-11-28

- Support to thread pausing during Network.attach;
- Ensure clear on PaymentChannel::close!.

### 2.0.4 - 2018-10-11

- Do not print last if not in communication thread;
- Replace sleep by getc at ParamsDat download functions;

### 2.0.3 - 2018-10-10

- Fix I18n print and translate to check line and column.

### 2.0.2 - 2018-10-05

- Fix system update removing file existence validation because it could be a not valid path.

### 2.0.1 - 2018-10-05

- Add support to create and close PaymentChannel from CommunicationChannel.

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