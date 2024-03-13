// assets
import NavigationOutlinedIcon from '@mui/icons-material/NavigationOutlined';
import HomeOutlinedIcon from '@mui/icons-material/HomeOutlined';

import GroupIcon from '@mui/icons-material/Group';
import EngineeringIcon from '@mui/icons-material/Engineering';
import PointOfSaleIcon from '@mui/icons-material/PointOfSale';
import SsidChartIcon from '@mui/icons-material/SsidChart';
import { currentMonth } from 'api/customFunction';

// eslint-disable-next-line
export default {
  items: [
    {
      id: 'navigation',
      title: 'Payrolls & Expenses WCE',
      caption: 'Peshawar Development Authority',
      type: 'group',
      icon: NavigationOutlinedIcon,
      children: [
        {
          id: 'dashboard',
          title: 'Dashboard',
          type: 'item',
          icon: HomeOutlinedIcon,
          url: '/dashboard'
        }
      ]
    },
    {
      id: 'pages',
      title: 'Pages',
      type: 'group',
      icon: NavigationOutlinedIcon,
      children: [
        {
          id: 'pay-rolls',
          title: 'Pay Rolls',
          type: 'collapse',
          icon: PointOfSaleIcon,
          children: [
            {
              id: 'create_update',
              title: 'create & update',
              type: 'item',
              url: '/pay-rolls',
              target: false
            },
            {
              id: 'payroll_print',
              title: 'Print',
              type: 'item',
              url: '/pay-rolls/print/' + currentMonth(),
              target: false
            }
          ]
        },
        {
          id: 'officials-list',
          title: 'Officials List',
          type: 'item',
          url: '/officials-list',
          icon: EngineeringIcon
        },
        {
          id: 'officials-extensions',
          title: 'Officials Extensions',
          type: 'item',
          url: '/officials-list',
          icon: SsidChartIcon
        }
      ]
    },

    {
      id: 'authentications',
      title: 'Authentications',
      type: 'group',
      icon: NavigationOutlinedIcon,
      children: [
        {
          id: 'user-list',
          title: 'User List',
          type: 'item',
          url: '/users',
          icon: GroupIcon
        }
      ]
    }
  ]
};
