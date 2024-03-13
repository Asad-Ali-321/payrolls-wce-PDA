import { requestGet } from './requestServer';

export const getUsers = async () => {
  try {
    const res = await requestGet('Users');
    debugger;
    return res;
  } catch (error) {
    return { status: false };
  }
};

export const unblockUser = async (user_id) => {
  try {
    const res = await requestGet('users/unblock/' + user_id);
    return res;
  } catch (error) {
    return { status: false };
  }
};

export const getOne = async (user_id) => {
  try {
    const res = await requestGet('users/getOne/' + user_id);
    return res;
  } catch (error) {
    return { status: false };
  }
};
