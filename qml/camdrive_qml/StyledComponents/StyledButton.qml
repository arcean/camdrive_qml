import QtQuick 1.1
import com.nokia.meego 1.0

ButtonStyle {
    pressedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-pressed" + (position ? "-" + position : "")
    checkedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-selected" + (position ? "-" + position : "")
    checkedDisabledBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-disabled-selected" + (position ? "-" + position : "")
}
