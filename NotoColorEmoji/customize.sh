#!/sbin/sh

#####################################
#     Android Emoji Changer
#                By
# Khun Htetz Naing(t.me/HtetzNaing)
#####################################

FONT_DIR=$MODPATH/system/fonts
DEF_FONT="NotoColorEmoji.ttf"
TARGET_FONTS='SamsungColorEmoji.ttf AndroidEmoji-htc.ttf ColorUniEmoji.ttf DcmColorEmoji.ttf CombinedColorEmoji.ttf'

# 1 for delete /data/fonts/files
ANDROID12_REPLACE=0
# 1 for normal mode
SMART_MODE=1

# Replace faceook & messnger emojis
fb_msg_emoji() {
    DATA_DIR="/data/data/"
    EMOJI_DIR="app_ras_blobs"
    TTF_NAME="FacebookEmoji.ttf"
    apps='com.facebook.orca com.facebook.katana'
    for i in $apps ; do  # NOTE: do not double-quote $services here.
        if [ -d "$DATA_DIR$i" ]; then
            if cd "$DATA_DIR$i"
            then
                if [ ! -d "$EMOJI_DIR" ]; then
                  mkdir $EMOJI_DIR
                fi

                if cd "$EMOJI_DIR"
                then
                    APP_NAME="Facebook"
                    if [ "${i#*orca}" != "$i" ]; then
                        APP_NAME="Messenger"
                    fi

                    # Change
                    if cp "$FONT_DIR/$DEF_FONT" ./$TTF_NAME; then
                        TTF_PATH="${DATA_DIR}${i}/${EMOJI_DIR}/${TTF_NAME}"
                        set_perm_recursive "$TTF_PATH" 0 0 0755 700
                        ui_print "- Replacing $APP_NAME Emojis ✅"
                    else
                        ui_print "- Replacing $APP_NAME Emojis ❎"
                    fi
                fi
            fi
        fi
    done
}

# Replace System Emoji
system_emoji(){
    ui_print "- Replacing $DEF_FONT ✅"
    for i in $TARGET_FONTS ; do
        if [ -f "/system/fonts/$i" ]; then
          if cp "$FONT_DIR/$DEF_FONT" "$FONT_DIR/$i"
          then
              ui_print "- Replacing $i ✅"
          else
            ui_print "- Replacing $i ❎"
          fi
        fi
    done
}

#Source: https://www.xda-developers.com/google-prepares-decouple-new-emojis-android-system-updates/
android12_replace_method(){
  DATA_FONT_DIR="/data/fonts/files"
  for dir in "$DATA_FONT_DIR"/*/ ; do
    if cd "$dir"
    then
      for file in * ; do
        if [ "${file##*.}" = "ttf" ]; then
          if cp "$FONT_DIR/$DEF_FONT" "$file"
          then
            ui_print "- Replacing $file ✅"
          else
            ui_print "- Replacing $file ❎"
          fi
        fi
      done
    fi
  done
}

android12_delete_method(){
  DATA_FONT_DIR="/data/fonts/files"
  for dir in "$DATA_FONT_DIR"/*/ ; do
    if rm -rf "$dir"
    then
      ui_print "- Delete $dir ✅"
    else
      ui_print "- Delete $dir ❎"
    fi
  done
}

# Android 12
android12(){
    android_ver=$(getprop ro.build.version.sdk)
    if [ "$android_ver" -ge 31 ]; then
        ui_print ""
        ui_print " ℹ️ Android 12 ✅"
        ui_print "******************"
        DATA_FONT_DIR="/data/fonts/files"
        if [ -d "$DATA_FONT_DIR" ] && [ "$(ls -A $DATA_FONT_DIR)" ]; then
            ui_print "- Checking [$DATA_FONT_DIR] ✅"
            if [ "$ANDROID12_REPLACE" = 0 ]; then
                ui_print "- Replace method❗"
                android12_replace_method
            else
                ui_print "- Delete method❗"
                android12_delete_method
            fi
        fi
    fi
}

#Replace system fonts
ui_print ""
if [ "$SMART_MODE" = 0 ]; then
    ui_print "*********************"
    ui_print "*  ℹ️ Smart mode 💜 *"
    ui_print "*********************"
    system_emoji
else
    ui_print "**********************"
    ui_print "*  ℹ️ Normal mode 💚 *"
    ui_print "**********************"
fi

#If emoji also replace facebook & messenger
fb_msg_emoji

#If Android 12 >=
android12
