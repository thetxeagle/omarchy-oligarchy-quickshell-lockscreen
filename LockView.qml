import QtQuick
import QtQuick.Effects
import qs.Commons
import qs.Ui
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io

Item {
  id: root

  property string backgroundPath: ""
  property int backgroundVersion: 0
  property bool fingerprintConfigured: false
  property bool authenticatingPassword: false
  property string failureMessage: ""
  property int failedAttempts: 0
  property bool inputEnabled: true
  property bool loadBackground: true
  property string passwordText: ""
  property bool syncingPasswordText: false
  property string oligarchyTagline: ""
  property string displayName: ""
  property string fallbackUsername: ""

  readonly property string homeDirectory: Quickshell.env("HOME")

  readonly property string placeholderText: "Enter Password"

  readonly property int fieldWidth: 340
  readonly property int fieldHeight: 48
  readonly property int outlineThickness: 1
  readonly property int fieldFontSize: 17
  readonly property int passwordDotFontSize: 18
  readonly property int passwordDotLetterSpacing: 3

  readonly property real passwordDotScale:
    dotMetrics.advanceWidth > 0
      ? Math.min(1, (passwordInput.width - 32) / dotMetrics.advanceWidth)
      : 1

  readonly property bool showPasswordCursor:
    inputEnabled &&
    !authenticatingPassword &&
    failureMessage.length === 0

  readonly property bool errorState:
    failureMessage.length > 0

  signal submitPassword(string password)
  signal passwordTextEdited(string password)
  signal clearFailureRequested()
  signal wakeRequested()

  function formatClock(date) {
    var hour = date.getHours()
    var minute = date.getMinutes()
    var suffix = hour >= 12 ? "PM" : "AM"

    hour = hour % 12

    if (hour === 0)
      hour = 12

    var minuteText =
      minute < 10
        ? "0" + minute
        : minute

    return hour + ":" + minuteText + " " + suffix
  }

  function forcePasswordFocus() {
    passwordInput.forceActiveFocus()
  }

  function clearPassword() {
    passwordTextEdited("")
  }

  function syncPasswordText() {
    if (passwordInput.text === passwordText)
      return

    syncingPasswordText = true
    passwordInput.text = passwordText
    syncingPasswordText = false
  }

  function randomizeOligarchyTagline() {
    if (!taglineProcess.running) {
      taglineProcess.running = true
    }
  }

  Process {
    id: taglineProcess

    command: [
      "bash",
      "-lc",
      "candidates=$(grep -Fvx -- \"$2\" \"$1\" || true); if [[ -n \"$candidates\" ]]; then printf '%s\\n' \"$candidates\" | shuf -n 1; else shuf -n 1 \"$1\"; fi",
      "tagline-picker",
      Qt.resolvedUrl("assets/taglines.txt").toString().replace(/^file:\/\//, ""),
      root.oligarchyTagline
    ]

    stdout: StdioCollector {
      waitForEnd: true

      onStreamFinished: {
        var value = String(text || "").trim()

        if (value.length > 0)
          root.oligarchyTagline = value
      }
    }
  }

  Process {
    id: displayNameProcess

    command: [
      "bash",
      "-lc",
      "if [[ -s \"$HOME/.displayName\" ]]; then cat \"$HOME/.displayName\"; else printf '%s' \"$USER\"; fi"
    ]

    stdout: StdioCollector {
      waitForEnd: true

      onStreamFinished: {
        var value = String(text || "").trim()

        root.displayName = value
      }
    }
  }

  onPasswordTextChanged: {
    syncPasswordText()
  }

  onInputEnabledChanged: {
    if (inputEnabled) {
      randomizeOligarchyTagline()
      Qt.callLater(forcePasswordFocus)
    }
  }

  Component.onCompleted: {
    syncPasswordText()

    randomizeOligarchyTagline()
    displayNameProcess.running = true

    if (inputEnabled)
      Qt.callLater(forcePasswordFocus)
  }

  /*
   * Keeps password focus alive after display wake.
   */
  Timer {
    interval: 250
    repeat: true
    running: root.inputEnabled && root.visible

    onTriggered: {
      if (!passwordInput.activeFocus)
        root.forcePasswordFocus()
    }
  }

  /*
   * Password-dot measurement.
   */
  TextMetrics {
    id: dotMetrics

    font.family: Style.font.family
    font.pixelSize: root.passwordDotFontSize
    font.letterSpacing: root.passwordDotLetterSpacing

    text: "●".repeat(passwordInput.text.length)
  }

  /*
   * BACKGROUND
   */
  Rectangle {
    anchors.fill: parent

    color: "#070707"

    Rectangle {
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      height: 1
      color: Color.accent
      opacity: 0.28
    }

    Rectangle {
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: 1
      color: Color.accent
      opacity: 0.18
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true

      onClicked: {
        root.wakeRequested()
        root.forcePasswordFocus()
      }

      onPositionChanged: {
        root.wakeRequested()
      }
    }

    /*
     * CLOCK + DATE
     */
    Column {
      id: clockGroup

      anchors.top: parent.top
      anchors.topMargin: Math.max(
        60,
        parent.height * 0.07
      )

      anchors.horizontalCenter: parent.horizontalCenter

      spacing: 7

      Text {
        anchors.horizontalCenter: parent.horizontalCenter

        text: "OLIGARCHY // SECURE SESSION"

        color: Color.accent
        opacity: 0.55

        font.family: Style.font.family
        font.pixelSize: 11
        font.letterSpacing: 3
        font.weight: Font.Medium

        horizontalAlignment: Text.AlignHCenter
      }

      Text {
        id: clockText

        anchors.horizontalCenter: parent.horizontalCenter

        text: root.formatClock(new Date())

        color: Color.accent

        font.family: Style.font.family

        font.pixelSize: Math.round(
          Math.min(root.width, root.height) * 0.078
        )

        font.weight: Font.Light

        horizontalAlignment: Text.AlignHCenter
      }

      Text {
        id: dateText

        anchors.horizontalCenter: parent.horizontalCenter

        text: Qt.formatDate(
          new Date(),
          "dddd, MMMM d"
        )

        color: Color.accent
        opacity: 0.75

        font.family: Style.font.family
        font.pixelSize: 21
        font.weight: Font.Normal

        horizontalAlignment: Text.AlignHCenter
      }
    }

    /*
     * Clock refresh.
     */
    Timer {
      interval: 1000
      running: true
      repeat: true

      onTriggered: {
        var now = new Date()

        clockText.text =
          root.formatClock(now)

        dateText.text =
          Qt.formatDate(
            now,
            "dddd, MMMM d"
          )
      }
    }

    /*
     * OMARCHY SVG WORDMARK
     *
     * Unlike the ASCII version, this has fixed geometry.
     * Qt no longer gets to improvise its own definition
     * of "centered."
    */
    Item {
      id: brandGroup

      width: Math.min(root.width * 0.66, 1280)
      height: width * 864 / 4321

      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter

      Rectangle {
        anchors.centerIn: parent
        width: parent.width * 1.10
        height: parent.height * 2.10
        radius: height / 2
        color: Color.accent
        opacity: 0.035

        layer.enabled: true

        layer.effect: MultiEffect {
          blurEnabled: true
          blur: 1.0
          blurMax: 64
        }
      }

      Image {
        id: omarchyWordmark

        anchors.centerIn: parent

        width: parent.width
        height: parent.height

        source: Qt.resolvedUrl("assets/generated/oligarchy-wordmark.png")

        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
        asynchronous: false
        cache: false

        layer.enabled: true

        layer.effect: MultiEffect {
          colorization: 1.0
          colorizationColor: Color.accent
        }
      }

      Text {
        id: oligarchyTaglineText

        anchors.top: brandGroup.bottom
        anchors.topMargin: 22
        anchors.horizontalCenter: parent.horizontalCenter

        width: Math.min(root.width * 0.66, 1280)

        text: root.oligarchyTagline

        color: Color.accent
        opacity: 0.78

        font.family: Style.font.family
        font.pixelSize: 22
        font.italic: false

        horizontalAlignment: Text.AlignHCenter

        wrapMode: Text.WordWrap
      }
    }

    /*
     * LOGIN AREA
     */
    Column {
      id: loginGroup

      anchors.bottom: parent.bottom

      anchors.bottomMargin: Math.max(
        72,
        parent.height * 0.075
      )

      anchors.horizontalCenter: parent.horizontalCenter

      spacing: 10

      Text {
        anchors.horizontalCenter: parent.horizontalCenter

        text: "AUTHORIZED IDENTITY"

        color: Color.accent
        opacity: 0.52

        font.family: Style.font.family
        font.pixelSize: 10
        font.letterSpacing: 2.4
        font.weight: Font.Medium

        horizontalAlignment: Text.AlignHCenter
      }

      /*
      * AVATAR
      */
      Item {
        id: avatarFrame

        width: 128
        height: 128

        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
          id: avatarOuterRing

          anchors.fill: parent
          anchors.margins: -6

          radius: width / 2
          color: "transparent"
          border.width: 1
          border.color: Color.accent
          opacity: 0.24
        }

        Rectangle {
          id: avatarBorder

          anchors.fill: parent

          radius: width / 2
          color: "#141414"

          border.width: 1
          border.color: Color.accent
        }

        Image {
          id: avatarImageSource

          anchors.fill: parent
          anchors.margins: 4

          source: homeDirectory.length > 0 ? "file://" + homeDirectory + "/.face" : ""

          fillMode: Image.PreserveAspectCrop

          smooth: true
          mipmap: true
          asynchronous: true

          sourceSize.width: 500
          sourceSize.height: 500

          visible: false
        }

        OpacityMask {
          anchors.fill: avatarImageSource

          source: avatarImageSource

          maskSource: Rectangle {
            width: avatarImageSource.width
            height: avatarImageSource.height
            radius: width / 2
            color: "black"
            visible: true
          }
        }

        Text {
          anchors.centerIn: parent

          visible: avatarImageSource.status !== Image.Ready

          text: "󰀄"

          color: Color.accent

          font.family: Style.font.family
          font.pixelSize: 50
        }
      }

      /*
       * USERNAME
       */
      Text {
        anchors.horizontalCenter: parent.horizontalCenter

        text: root.displayName

        color: Color.accent

        font.family: Style.font.family
        font.pixelSize: 17
        font.weight: Font.Medium

        horizontalAlignment: Text.AlignHCenter
      }

      /*
       * PASSWORD FIELD
       */
      Rectangle {
        id: inputField

        width: Math.min(root.fieldWidth + 20, root.width * 0.9)
        height: root.fieldHeight + 6

        anchors.horizontalCenter: parent.horizontalCenter

        radius: 10

        color: "#0d0d0d"

        border.width: root.outlineThickness

        border.color:
          root.errorState
            ? Color.lock.borderError
            : Color.accent

        clip: true

        TextInput {
          id: passwordInput

          anchors.fill: parent

          anchors.leftMargin: 18
          anchors.rightMargin: 18

          verticalAlignment:
            TextInput.AlignVCenter

          horizontalAlignment:
            TextInput.AlignHCenter

          activeFocusOnPress: true
          clip: true

          enabled:
            root.inputEnabled &&
            !root.authenticatingPassword

          readOnly:
            root.authenticatingPassword

          echoMode:
            TextInput.Password

          passwordCharacter:
            "\u25CF"

          passwordMaskDelay: 0

          color:
            Color.accent

          selectionColor:
            Color.lock.selection

          selectedTextColor:
            Color.accent

          font.family:
            Style.font.family

          font.pixelSize:
            text.length > 0
              ? Math.max(
                  1,
                  Math.floor(
                    root.passwordDotFontSize *
                    root.passwordDotScale
                  )
                )
              : root.fieldFontSize

          font.letterSpacing:
            text.length > 0
              ? root.passwordDotLetterSpacing *
                root.passwordDotScale
              : 0

          cursorVisible:
            activeFocus &&
            root.showPasswordCursor &&
            text.length > 0

          cursorDelegate: Rectangle {
            width: 1

            color: Color.accent

            visible:
              passwordInput.cursorVisible
          }

          onTextChanged: {
            if (!root.syncingPasswordText)
              root.passwordTextEdited(text)

            if (text.length > 0)
              root.wakeRequested()

            if (
              text.length > 0 &&
              root.failureMessage.length > 0
            ) {
              root.clearFailureRequested()
            }
          }

          onAccepted: {
            var submitted =
              root.passwordText

            root.passwordTextEdited("")

            if (submitted.length > 0)
              root.submitPassword(submitted)
          }

          Keys.onPressed: function(event) {
            root.wakeRequested()

            if (
              event.key === Qt.Key_Escape ||
              (
                event.modifiers &
                Qt.ControlModifier &&
                event.key === Qt.Key_U
              )
            ) {
              root.passwordTextEdited("")
              event.accepted = true
            }
          }
        }

        /*
         * Placeholder / authentication / error text.
         */
        Text {
          anchors.fill: passwordInput

          visible:
            passwordInput.text.length === 0

          text:
            root.authenticatingPassword
              ? "Checking…"
              : (
                  root.failureMessage.length > 0
                    ? root.failureMessage
                    : root.placeholderText
                )

          color:
            root.failureMessage.length > 0
              ? Color.lock.textError
              : Color.accent

          font.family:
            Style.font.family

          font.pixelSize: 16

          horizontalAlignment:
            Text.AlignHCenter

          verticalAlignment:
            Text.AlignVCenter

          elide:
            Text.ElideRight
        }
      }

      /*
       * FINGERPRINT STATUS
       */
      Row {
        anchors.horizontalCenter:
          parent.horizontalCenter

        visible:
          root.fingerprintConfigured

        spacing: 7

        Text {
          text: "󰈷"

          color: Color.accent

          font.family:
            Style.font.family

          font.pixelSize: 16
        }

        Text {
          text:
            "Fingerprint available"

          color:
            Color.accent

          font.family:
            Style.font.family

          font.pixelSize: 13
        }
      }
    }
  }
}
