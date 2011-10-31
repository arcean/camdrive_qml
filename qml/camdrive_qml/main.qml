import QtQuick 1.0

import com.meego 1.0

PageStackWindow {
    id: appWindow
    initialPage: mainPage
    showToolBar: false

    platformStyle: PageStackWindowStyle {
        background: "qrc:/icons/background.png"
        backgroundFillMode: Image.Tile
    }

    ViewfinderPage{id: viewfinderPage}
    MainPage{id: mainPage}

    Component.onCompleted: {
        theme.inverted = true
       // theme.color = 8

    }

    ToolBarLayout {
        id: commonTools

        visible: false
        ToolIcon { platformIconId: "toolbar-view-menu";
            anchors.right: parent===undefined ? undefined : parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: "Sample menu item" }
        }
    }
}


