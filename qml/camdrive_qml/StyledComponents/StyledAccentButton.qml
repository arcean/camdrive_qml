import QtQuick 1.0
import com.nokia.meego 1.0

ButtonStyle {
    background: "image://theme/" + _ACTIVE_COLOR + "-" + "meegotouch-button-accent" + __invertedString + "-background" + (position ? "-" + position : "")
    pressedBackground: "image://theme/" + _ACTIVE_COLOR + "-" + "meegotouch-button-accent" + __invertedString + "-background-pressed" + (position ? "-" + position : "")
    checkedBackground: "image://theme/" + _ACTIVE_COLOR + "-" + "meegotouch-button-accent" + __invertedString + "-background-selected" + (position ? "-" + position : "")
    checkedDisabledBackground: "image://theme/" + _ACTIVE_COLOR + "-" + "meegotouch-button-accent" + __invertedString + "-background-disabled-selected" + (position ? "-" + position : "")
}
