/*
*  Copyright 2021 Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of Latte-Dock
*
*  Latte-Dock is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License as
*  published by the Free Software Foundation; either version 2 of
*  the License, or (at your option) any later version.
*
*  Latte-Dock is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.7

import org.kde.latte.abilities.definition 0.1 as AbilityDefinition

AbilityDefinition.ThinTooltip {
    id: thinTooltip
    property Item bridge: null

    isEnabled: ref.thinTooltip.isEnabled
    showIsBlocked: local.showIsBlocked
    currentVisualParent: ref.thinTooltip.currentVisualParent
    currentText: ref.thinTooltip.currentText

    readonly property bool isActive: bridge !== null
    readonly property AbilityDefinition.ThinTooltip local: AbilityDefinition.ThinTooltip {}

    Item {
        id: ref
        readonly property Item thinTooltip: bridge ? bridge.thinTooltip.host : local
    }

    function show(visualParent, text) {
        if (bridge) {
            bridge.thinTooltip.host.show(visualParent, text);
        } else {
            local.show(visualParent, text);
        }
    }

    function hide(visualParent) {
        if (bridge) {
            bridge.thinTooltip.host.hide(visualParent);
        } else {
            local.hide(visualParent);
        }
    }

    onIsActiveChanged: {
        if (isActive) {
            bridge.thinTooltip.client = thinTooltip;
        }
    }

    Component.onCompleted: {
        if (isActive) {
            bridge.thinTooltip.client = thinTooltip;
        }
    }

    Component.onDestruction: {
        if (isActive) {
            bridge.thinTooltip.client = null;
        }
    }
}
