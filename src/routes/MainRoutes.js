import React, { lazy } from 'react';

// project import
import MainLayout from 'layout/MainLayout';
import Loadable from 'component/Loadable';
import Officials from 'views/Officials';

const DashboardDefault = Loadable(lazy(() => import('../views/Dashboard')));


const SamplePage = Loadable(lazy(() => import('../views/SamplePage')));

// ==============================|| MAIN ROUTES ||============================== //

const MainRoutes = {
  path: '/',
  element: <MainLayout />,
  children: [
    {
      path: '/',
      element: <DashboardDefault />
    },
    { path: '/sample-page', element: <SamplePage /> },

    // Officials
    { path: '/officials-list', element: <Officials /> }
  ]
};

export default MainRoutes;
