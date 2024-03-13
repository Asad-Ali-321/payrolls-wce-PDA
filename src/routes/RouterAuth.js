import { Outlet, Navigate } from 'react-router-dom';

const RouterAuth = () => {
  let auth = { token: localStorage.getItem('user') };
  return auth.token ? <Outlet /> : <Navigate to="/" />;
};

export default RouterAuth;
