import { requestPost } from './requestServer';

export const deleteRecord = async (collection, condition) => {
  try {
    
    return await requestPost('Crud/delete', {
      collection: collection,
      where: condition
    });
  } catch (error) {
    return false; // Return false in case of an error
  }
};

export const getDaysInMonth = (year, month) => {
  const lastDayOfMonth = new Date(year, month + 1, 0);
  // Get the day of the month (0-31)
  return lastDayOfMonth.getDate();
};

export const currentMonth = () => {
  const currentDate = new Date();
  const currentYear = currentDate.getFullYear();
  const currentMonth = currentDate.getMonth() + 1;
  return `${currentYear}-${currentMonth.toString().padStart(2, '0')}`;
};
