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
import Directorates from 'views/Directorates';
import Designations from 'views/Designations';
import ChargeableHeads from 'views/ChargeableHeads';
import PayRollCreate from 'views/Payroll/create';
const DashboardDefault = Loadable(lazy(() => import('../views/Dashboard')));

const SamplePage = Loadable(lazy(() => import('../views/SamplePage')));

// ==============================|| MAIN ROUTES ||============================== //

const RoutingDirectory = (
  <Routes>
    <Route element={<RouterAuth />}>
      <Route element={<MainLayout />}>
        <Route path="*" element={<DashboardDefault />} />
        <Route path="/dashboard" element={<DashboardDefault />} />
        <Route path="/sample-page" element={<SamplePage />} />

        <Route path="/officials-list" element={<Officials />} />

        {/* configurations */}
        <Route path="/pay-rolls" element={<PayRolls />} />
        <Route path="/pay-rolls/create" element={<PayRollCreate />} />
        <Route path="/pay-rolls/print/:month" element={<Print />} />
        {/* configurations */}

        <Route path="/users" element={<Users />} />

        {/* configurations */}
        <Route path="/directorates" element={<Directorates />} />
        <Route path="/designations" element={<Designations />} />
        <Route path="/chargeable-heads" element={<ChargeableHeads />} />
      </Route>
    </Route>
    <Route path="/" element={<Login />} />
  </Routes>
);

export default RoutingDirectory;
