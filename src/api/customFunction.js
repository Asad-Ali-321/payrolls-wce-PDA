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

export const daysCountInMonth = (monthYear) => {
  const year = monthYear.split('-')[0];
  const month = monthYear.split('-')[1];
  // JavaScript months are zero-indexed (0 = January, 1 = February, ..., 11 = December)
  // To get the last day of the month, set the day to 0 of the next month
  return new Date(year, month + 1, 0).getDate();
};
