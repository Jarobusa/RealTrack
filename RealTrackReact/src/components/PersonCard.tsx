import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import type { Person } from '../types/person';

type Props = {
  person: Person;
};

export function PersonCard({ person }: Props) {
  return (
    <View style={styles.card}>
      <Text style={styles.name}>
        {person.firstName} {person.lastName}
      </Text>
      <Text style={styles.meta}>Email: {person.email}</Text>
      {person.phone ? <Text style={styles.meta}>Phone: {person.phone}</Text> : null}
      <Text style={styles.meta}>Person ID: {person.personId}</Text>
      <Text style={styles.meta}>Created: {formatDate(person.createdUtc)}</Text>
      <Text style={styles.meta}>Updated: {formatDate(person.updatedUtc)}</Text>
    </View>
  );
}

const formatDate = (value: string) =>
  new Date(value).toLocaleString(undefined, { hour12: false });

const styles = StyleSheet.create({
  card: {
    backgroundColor: '#1f2937',
    borderRadius: 12,
    padding: 16,
    borderWidth: 1,
    borderColor: '#334155',
    marginBottom: 12
  },
  name: {
    fontSize: 18,
    fontWeight: '700',
    color: '#f8fafc',
    marginBottom: 4
  },
  meta: {
    color: '#cbd5f5',
    marginBottom: 2
  }
});
