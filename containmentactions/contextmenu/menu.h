/*
*  Copyright 2018 Michail Vourlakos <mvourlakos@gmail.com>
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

#ifndef MENU_H
#define MENU_H

// Qt
#include <QObject>

// Plasma
#include <Plasma/ContainmentActions>

class QAction;
class QMenu;

class Menu : public Plasma::ContainmentActions
{
    Q_OBJECT

public:
    Menu(QObject *parent, const QVariantList &args);
    ~Menu() override;

    QList<QAction *> contextualActions() override;

    QAction *action(const QString &name);
private Q_SLOTS:
    void makeActions();
    void onUserConfiguringChanged(const bool &configuring);
    void populateLayouts();
    void quitApplication();
    void requestConfiguration();
    void requestWidgetExplorer();
    void switchToLayout(QAction *action);


private:
    QStringList m_data;

    QList<QAction *>m_actions;

    QAction *m_sectionAction{nullptr};
    QAction *m_separator{nullptr};

    QAction *m_addWidgetsAction{nullptr};
    QAction *m_configureAction{nullptr};
    QAction *m_duplicateAction{nullptr};
    QAction *m_exportViewAction{nullptr};
    QAction *m_printAction{nullptr};
    QAction *m_layoutsAction{nullptr};
    QAction *m_preferenceAction{nullptr};
    QAction *m_removeAction{nullptr};
    QAction *m_quitApplication{nullptr};

    QMenu *m_switchLayoutsMenu{nullptr};
};

#endif
