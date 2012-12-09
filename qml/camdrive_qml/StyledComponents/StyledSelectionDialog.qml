import QtQuick 1.1
import com.nokia.meego 1.0

SelectionDialog {
    platformStyle: SelectionDialogStyle {
        itemSelectedBackground: "image://theme/" + _ACTIVE_COLOR + "-" + "meegotouch-list-fullwidth-background-selected"
        itemPressedBackground: "image://theme/" + _ACTIVE_COLOR + "-" + "meegotouch-button-inverted-background-pressed-vertical-center"
    }
}
