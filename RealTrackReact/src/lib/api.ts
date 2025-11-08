import Constants from 'expo-constants';
import type { Person } from '../types/person';

const configUrl = (Constants.expoConfig?.extra as { apiUrl?: string } | undefined)?.apiUrl;
const BASE_URL = (process.env.EXPO_PUBLIC_REALTRACK_API_URL ?? configUrl ?? 'http://localhost:5233').replace(/\/$/, '');

type RequestInitInput = Omit<RequestInit, 'body'> & { body?: BodyInit | null };

class ApiError extends Error {
  constructor(
    message: string,
    public status: number
  ) {
    super(message);
  }
}

async function request<T>(path: string, init?: RequestInitInput): Promise<T> {
  const response = await fetch(`${BASE_URL}${path}`, {
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
      ...init?.headers
    },
    ...init
  });

  if (!response.ok) {
    const text = await response.text();
    throw new ApiError(text || `Request failed (${response.status}).`, response.status);
  }

  if (response.status === 204) {
    return null as T;
  }

  return response.json() as Promise<T>;
}

const normalizePerson = (payload: any): Person => ({
  personId: payload.personId,
  firstName: payload.firstName,
  lastName: payload.lastName,
  email: payload.email,
  phone: payload.phone,
  createdUtc: payload.createdUtc,
  updatedUtc: payload.updatedUtc
});

export function createPersonClient() {
  return {
    async getByEmail(email: string): Promise<Person | null> {
      try {
        const person = await request<Person>(`/persons?email=${encodeURIComponent(email)}`);
        return person ? normalizePerson(person) : null;
      } catch (error) {
        if (error instanceof ApiError && error.status === 404) {
          return null;
        }
        throw error;
      }
    },
    async getById(personId: string): Promise<Person | null> {
      try {
        const person = await request<Person>(`/persons/${encodeURIComponent(personId)}`);
        return person ? normalizePerson(person) : null;
      } catch (error) {
        if (error instanceof ApiError && error.status === 404) {
          return null;
        }
        throw error;
      }
    },
    async searchByLastName(lastName: string, prefix: boolean): Promise<Person[]> {
      const people = await request<Person[]>(
        `/persons?lastName=${encodeURIComponent(lastName)}&prefix=${prefix}`
      );
      return Array.isArray(people) ? people.map(normalizePerson) : [];
    }
  };
}
