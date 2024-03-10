export const defaultInputProps = {
  variant: 'outlined',
  size: 'medium',
  fullWidth: true
};

export const assignTo = ['Admin', 'Operator', 'Manager'];
export const complaintPriorities = ['High', 'Medium', 'Low', 'Critical'];
export const complaintCategories = ['Fraud', 'Misbehave', 'Critical'];
export const clientStatus = ['active', 'in_active', 'blocked'];
export const driverStatus = ['active', 'in_active', 'blocked'];
export const operatorStatus = ['active', 'in_active', 'blocked'];
export const operatorRoles = ['operator', 'admin', 'super_admin'];
export const rideStatus = ['pending', 'proceeding', 'canceled', 'rejected', 'completed'];
export const vehicleTypes = ['Car', 'Vane', 'Truck', 'Other'];
export const driverProfileTabs = [
  { label: 'Basic Info', href: '/users/drivers/edit/' },
  { label: 'Identity Proof', href: '/users/drivers/edit/identity-proof/' },
  { label: 'Driving Licenses', href: '/users/drivers/edit/driving-licenses/' },
  { label: 'Vehicles Registrations', href: '/users/drivers/edit/vehicles-registrations/' },
  { label: 'Vehicles Insurances', href: '/users/drivers/edit/vehicles-insurances/' },
  { label: 'National Police Checks', href: '/users/drivers/edit/national-police-checks/' },
  { label: 'NSW Driving Records', href: '/users/drivers/edit/nsw-driving-records/' }
];
export const documentStatus = ['pending', 'in_process', 'approved', 'rejected'];
export const documentStatusBadge = (status) => {
  switch (status) {
    case 'pending':
      return '';
    case 'in_process':
      return '';
    case 'approved':
      return '';
    case 'rejected':
      return '';

    default:
      break;
  }
};
