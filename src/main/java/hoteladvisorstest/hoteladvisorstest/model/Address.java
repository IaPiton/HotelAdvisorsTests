package hoteladvisorstest.hoteladvisorstest.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "address")
public class Address {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    @Column(name = "city")
    private String city;

    @Column(name = "street")
    private String street;

    @Column(name = "house")
    private Integer house;

    @Column(name = "flat")
    private Integer flat;

    @OneToOne(mappedBy = "address")
    private Company company;
    @OneToOne(mappedBy = "address")
    private Branch branch;

}
