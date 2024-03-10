import { requestGet, requestPost } from './requestServer';

export const typeAndCountryWiseUsers = async (countries, type) => {
  try {
    const res = await requestPost('users/type-and-country-wise-users', { countries: countries.join(','), type: type });
    return res.data;
  } catch (error) {
    return false; // Return false in case of an error
  }
};
export const stateWiseCities = async (state) => {
  try {
    const res = await requestGet('cities/state-wise-cities/' + state);
    return res.data;
  } catch (error) {
    return false; // Return false in case of an error
  }
};

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
