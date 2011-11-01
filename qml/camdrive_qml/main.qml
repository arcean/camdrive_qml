import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow
    initialPage: mainPage
    showToolBar: false

    platformStyle: PageStackWindowStyle {
        background: "qrc:/icons/background.png"
        backgroundFillMode: Image.Tile
    }

    ViewfinderPage {id: viewfinderPage}
    MainPage {id: mainPage}
    SettingsPage {id: settingsPage}

    Component.onCompleted: {
        theme.inverted = true
       // theme.color = 8
    }

    ToolBarLayout {
        id: commonTools

        visible: false
        ToolIcon { platformIconId: "toolbar-back";
            anchors.left: parent.left
            onClicked: {
                pageStack.pop()
                hideToolbar()
            }
        }
    }
/*
    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: "Sample menu item" }
        }
    }
*/
    function showToolbar()
    {
        appWindow.showToolBar = true
        commonTools.visible = true
    }

    function hideToolbar()
    {
        appWindow.showToolBar = false
        commonTools.visible = false
    }
}


