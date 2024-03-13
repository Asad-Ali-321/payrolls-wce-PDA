import React, { lazy } from 'react';

// project import
import MainLayout from 'layout/MainLayout';
import Loadable from 'component/Loadable';
import Officials from 'views/Officials';
import PayRolls from 'views/Payroll';
import { Print } from 'views/Payroll/print';
import { Route, Routes } from 'react-router';
import RouterAuth from './RouterAuth';
import Login from 'views/Login';
import Users from 'views/Users';
const DashboardDefault = Loadable(lazy(() => import('../views/Dashboard')));

const SamplePage = Loadable(lazy(() => import('../views/SamplePage')));

// ==============================|| MAIN ROUTES ||============================== //

const RoutingDirectory = (
  <Routes>
    <Route element={<RouterAuth />}>
      <Route element={<MainLayout />}>
        <Route path="/dashboard" element={<DashboardDefault />} />
        <Route path="/sample-page" element={<SamplePage />} />

        <Route path="/officials-list" element={<Officials />} />

        <Route path="/pay-rolls" element={<PayRolls />} />
        <Route path="/pay-rolls/print/:month" element={<Print />} />

        <Route path="/users" element={<Users />} />
      </Route>
    </Route>
    <Route path="*" element={<Login />} />
  </Routes>
);

export default RoutingDirectory;
