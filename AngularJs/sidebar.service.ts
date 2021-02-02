import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class SidebarService {
  toggled = false;
  _hasBackgroundImage = true;
  menus = [
    {
      title: 'KONTROL EKRANI',
      type: 'header'
    },
    {
      title: 'Ana Sayfa',
      icon: 'fa fa-home',
      active: false,
      type: 'dropdown',
      // badge: {
      //   text: '',
      //   class: 'badge-warning'
      // },
      submenus: [
        {
          title: 'Deneme 1',
          badge: {
            text: 'Pro ',
            class: 'badge-success'
          }
        },
        {
          title: 'Deneme 2'
        },
        {
          title: 'Deneme 3'
        }
      ]
    },
    {
      title: 'Projelerim',
      icon: 'fa fa-project-diagram',
      active: false,
      type: 'dropdown',
      badge: {
        text: '3',
        class: 'badge-danger'
      },
      submenus: [
        {
          title: 'Bitirilen',
        },
        {
          title: 'Devam Eden'
        },
        {
          title: 'Başlanacak'
        }
      ]
    },
    {
      title: 'Görevler',
      icon: 'far fa-gem',
      active: false,
      type: 'dropdown',
      submenus: [
        {
          title: 'Genel Projeler',
        },
        {
          title: 'Özel Projeler'
        },
        {
          title: 'Planlama'
        }
      ]
    },
    {
      title: 'Grafikler',
      icon: 'fa fa-chart-line',
      active: false,
      type: 'dropdown',
      submenus: [
        {
          title: 'Pie chart',
        },
        {
          title: 'Line chart'
        },
        {
          title: 'Bar chart'
        },
        {
          title: 'Histogram'
        }
      ]
    },
    {
      title: 'Görev Haritası',
      icon: 'fa fa-globe',
      active: false,
      type: 'dropdown',
      submenus: [
        {
          title: 'Yakında...',
        }
      ]
    },
    {
      title: 'Proje Detayları',
      type: 'header'
    },
    {
      title: 'Belgelerim',
      icon: 'fa fa-book',
      active: false,
      type: 'simple',
      badge: {
        text: 'Beta',
        class: 'badge-primary'
      },
    },
    {
      title: 'Proje Yöenetimi',
      icon: 'fa fa-calendar',
      active: false,
      type: 'simple'
    },
    {
      title: 'Örnekler',
      icon: 'fa fa-folder',
      active: false,
      type: 'simple'
    }
  ];
  constructor() { }

  toggle() {
    this.toggled = ! this.toggled;
  }

  getSidebarState() {
    return this.toggled;
  }

  setSidebarState(state: boolean) {
    this.toggled = state;
  }

  getMenuList() {
    return this.menus;
  }

  get hasBackgroundImage() {
    return this._hasBackgroundImage;
  }

  set hasBackgroundImage(hasBackgroundImage) {
    this._hasBackgroundImage = hasBackgroundImage;
  }
}
