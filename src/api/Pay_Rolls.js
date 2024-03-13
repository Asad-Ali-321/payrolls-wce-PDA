const { requestGet, requestPost } = require('./requestServer');

export const getMonthlyPayRolls = async (month) => {
  try {
    const res = await requestGet('pay_rolls/index/' + month);
    return res;
  } catch (error) {
    return { status: false };
  }
};

export const updateRow = async (month, row) => {
  try {
    const body = {
      official_id: row.official_id,
      month: month,
      monthly_pay: row.monthly_pay,
      income_tax: row.income_tax,
      attendance: row.attendance,
      deductions: row.deductions,
      net_salary: row.net_salary
    };
    const res = await requestPost('pay_rolls/updateRow/', body);
    return res;
  } catch (error) {
    
    return { status: false };
  }
};
