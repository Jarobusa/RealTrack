export type Person = {
  personId: string;
  firstName: string;
  lastName: string;
  email: string;
  phone?: string | null;
  createdUtc: string;
  updatedUtc: string;
};
